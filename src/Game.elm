module Game where

import Graphics.Element exposing (show)
import Flock
import Html exposing (..)
import Types exposing (..)

view : Model -> Html
view model =
  div [] [
    text ("Score: " ++ (toString model.score)),
    Flock.view model
  ]
