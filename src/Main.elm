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

type alias Keys = { x:Int, y:Int }

type alias Model =
  { screen: Screen
  , lastPressTime: Int
  , points: Int
  }

initialModel: Model
initialModel =
  { screen = Menu,
    lastPressTime = 0,
    points = 0
  }

update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    ChangeScreen screen ->
      {model | screen <- screen}
    ResetPoints ->
      {model | points <- 0}
    SetLastPressTime time ->
      {model | lastPressTime <- time}



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
      Game.view address
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
  -- (x /= 0 || y /= 0) && (x == 0 || y == 0)
  xor (x /= 0) (y /= 0)

keysToAnswer : Keys -> Action
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
    |> Signal.filter isArrowPressed
    |> Signal.map keysToAnswer
    |> Time.timestamp
    |> Signal.map (\(time, action) -> action time)
