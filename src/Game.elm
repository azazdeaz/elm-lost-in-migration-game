module Game where

import Graphics.Element exposing (show)
import Flock
import Html exposing (..)
import Types exposing (..)
import Time exposing (second)
import Basics exposing (truncate)

view : Model -> Html
view model =
  let
    time =
      truncate (model.gameElapsedTime / second)
  in
    div [] [
      text ("Score: " ++ (toString model.score)),
      text ("Time: " ++ (toString time)),
      Flock.view model
    ]
