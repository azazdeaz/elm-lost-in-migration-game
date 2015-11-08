--import Turtle exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import Signal exposing (Address)
import Game

-- main = animate steps
type Screen = Menu | Game | HowTo
type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | SetLastPressTime Int

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
      {model | SetLastPressTime <- time}



menu: Address Action -> Html
menu address =
  div [] [
    button [onClick address (ChangeScreen Game)][ text "Game" ],
    button [onClick address (ChangeScreen HowTo)][ text "How To?" ]
  ]

game: Html
game =
  Game.test

--steps = [forward 20, left 90, forward 10, right 78, forward 500]
view: Address Action -> Model -> Html
view address model =
  case model.screen of
    Menu ->
      menu address
    Game ->
      game
    HowTo ->
      text "HowTo"--animate steps


main: Signal Html
main = StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }
