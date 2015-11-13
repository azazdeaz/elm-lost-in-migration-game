--import Turtle exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import Signal exposing (Address)
import Types exposing (..)
import Game
import Time
import Window
import Keyboard
import Graphics.Element exposing (..)

-- main = animate steps

initialModel: Model
initialModel =
  { screen = Menu,
    lastPressTime = 0,
    points = 0
  }

update: Action -> Model -> Model
update action model =
  let
    setAnswer : Time.Time -> Model
    setAnswer time =
      {model | lastPressTime <- round time}
  in
    case action of
      NoOp ->
        model
      ChangeScreen screen ->
        {model | screen <- screen}
      ResetPoints ->
        {model | points <- 0}
      AnswerTop time ->
        setAnswer time
      AnswerRight time ->
        setAnswer time
      AnswerBottom time ->
        setAnswer time
      AnswerLeft time ->
        setAnswer time



menu: Address Action -> Html
menu address =
  div [] [
    button [onClick address (ChangeScreen Game)][ text "Game" ],
    button [onClick address (ChangeScreen HowTo)][ text "How To?" ]
  ]

--steps = [forward 20, left 90, forward 10, right 78, forward 500]
--view: Address Action -> Model -> Html
view address (w',h') model =
  case model.screen of
    Menu ->
      menu address
    Game ->
      Game.view model
    HowTo ->
      text "HowTo"--animate steps


-- SIGNALS

main : Signal Html
main =
  Signal.map2 (view inbox.address) Window.dimensions (Signal.foldp update initialModel input)

input : Signal Action
input =
  Signal.merge answer inbox.signal

inbox : Signal.Mailbox Action
inbox = Signal.mailbox NoOp

isArrowPressed : Keys -> Bool
isArrowPressed {x, y} =
  xor (x /= 0) (y /= 0)

keysToAnswer : Keys -> Time.Time -> Action
keysToAnswer {x, y} =
  case (x, y) of
    (0, 1) ->
      AnswerTop
    (1, 0) ->
      AnswerRight
    (0, -1) ->
      AnswerBottom
    (-1, 0) ->
      AnswerLeft
    _ ->
      AnswerLeft


answer : Signal Action
answer =
  Keyboard.arrows
    |> Signal.filter isArrowPressed {x = 1, y = 0}
    |> Signal.map keysToAnswer
    |> Time.timestamp
    |> Signal.map (\(time, action) -> action time)
