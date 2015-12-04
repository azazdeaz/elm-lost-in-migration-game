module Game where

import Flock
import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Time exposing (second)
import Basics exposing (truncate)

view : Model -> Html
view model =
  let
    time =
      truncate ((toFloat model.gameElapsedTime) / second)
    progress =
      toString (((toFloat model.gameElapsedTime) / 12 * second) * 100)
  in
    div [] [
      text ("Score: " ++ (toString model.score)),
      text ("Time: " ++ (toString time)),
      node "paper-progress" [attribute "value" progress] [],
      Flock.view model
    ]
