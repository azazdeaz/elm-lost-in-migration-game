--import Turtle exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, style, attribute)
import Html.Events exposing (onClick)
import Signal exposing (Address)
import Types exposing (..)
import Game
import Time
import Keyboard
import Random
import Random.Array exposing (sample)
import Array
import Maybe exposing (withDefault)

-- main = animate steps

initialModel: Model
initialModel =
  { screen = Menu
  , seed = Random.initialSeed 0
  , goodDirection = Left
  , score = 200
  , gameElapsedTime = 0
  , gameWidth = 600
  , gameHeight = 400
  }

update: Action -> Model -> Model
update action model =
  let
    seed : Float -> Random.Seed
    seed time =
      Random.initialSeed (round time)

    answers =
      Array.fromList [Up, Left, Right, Down]

    generateNextDirection : Float -> (Maybe Direction, Random.Seed)
    generateNextDirection time =
      sample (seed time) answers

    direction : Float -> Direction
    direction time =
      time
        |> generateNextDirection
        |> fst
        |> withDefault Left

    nextScore model answerDirection =
       if model.goodDirection == answerDirection
         then model.score + 200
         else model.score

    setAnswer : Model -> Direction -> Time.Time -> Model
    setAnswer model answerDirection time =
      {model |
        score = nextScore model answerDirection,
        seed = snd (generateNextDirection time),
        goodDirection = direction time
      }

    increaseGameElapsedTime delta model =
      if model.screen == Game then
        {model | gameElapsedTime = model.gameElapsedTime + delta}
      else
        model

    checkGameEnd model =
      if model.gameElapsedTime >= Time.second * 12 then
        {model | screen = Menu}
      else
        model

  in
    case action of
      NoOp ->
        model
      Tick delta->
        model
          |> increaseGameElapsedTime delta
          |> checkGameEnd
      ChangeScreen screen ->
        {model |
          screen = screen,
          gameElapsedTime = if screen == Game then 0 else model.gameElapsedTime
        }
      ResetScore ->
        {model | score = 0}
      Answer direction time ->
        setAnswer model direction time



menu: Address Action -> Html
menu address =
  div [] [
    node "paper-button"
      [ onClick address (ChangeScreen Game)
      , attribute "raised" "true"
      ]
      [ text "Game" ],
    node "paper-button"
      [ onClick address (ChangeScreen HowTo)
      ,  attribute "raised" "true"
      ]
      [ text "How To?" ]
  ]

frame : Model -> Html -> Html
frame model content =
  div [
    style
      [ ("width", (toString model.gameWidth) ++ "px")
      , ("height", (toString model.gameHeight) ++ "px")
      , ("background-color", "#7FDBFF")
      , ("poistion", "absolute")
      ]
  ]
  [ content ]

--steps = [forward 20, left 90, forward 10, right 78, forward 500]
view : Address Action -> Model -> Html
view address model =
  let
    content =
      case model.screen of
        Menu ->
          menu address
        Game ->
          Game.view model
        HowTo ->
          text "HowTo"--animate steps
  in
    frame model content


-- SIGNALS

main : Signal Html
main =
  Signal.map (view inbox.address) (Signal.foldp update initialModel input)

input : Signal Action
input =
  Signal.mergeMany [answer, inbox.signal, tick]

tick : Signal Action
tick =
  Time.fps 60
    |> Signal.map (\delta -> Tick delta)

inbox : Signal.Mailbox Action
inbox = Signal.mailbox NoOp

isArrowPressed : Keys -> Bool
isArrowPressed {x, y} =
  xor (x /= 0) (y /= 0)

keysToAnswer : Keys -> Time.Time -> Action
keysToAnswer {x, y} =
  case (x, y) of
    (0, 1) ->
      Answer Up
    (1, 0) ->
      Answer Right
    (0, -1) ->
      Answer Down
    (-1, 0) ->
      Answer Left
    _ ->
      Answer Left


answer : Signal Action
answer =
  Keyboard.arrows
    |> Signal.filter isArrowPressed {x = 1, y = 0}
    |> Signal.map keysToAnswer
    |> Time.timestamp
    |> Signal.map (\(time, action) -> action time)
