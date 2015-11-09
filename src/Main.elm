--import Turtle exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import Signal exposing (Address)
import Types exposing (..)
import Game

-- main = animate steps

type alias Model =
  { screen: Screen
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
view : (Int, Int) -> Model -> Element
view (w',h') model =
  case model.screen of
    Menu ->
      menu address
    Game ->
      Game.view address
    HowTo ->
      text "HowTo"--animate steps


-- SIGNALS

main : Signal Element
main =
  Signal.map2 view Window.dimensions (Signal.foldp update mario input)


input : Signal (Float, Keys)
input =
  let
    delta = Signal.map (\t -> t/20) (fps 30)
  in
    Signal.sampleOn delta (Signal.map2 (,) delta Keyboard.arrows)
