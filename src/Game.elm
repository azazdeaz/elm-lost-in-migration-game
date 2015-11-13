module Game where

import Graphics.Element exposing (show)
import Flock
import Html exposing (..)
import Types exposing (..)

view : Model -> Html
view model =
  div [] [
    text (toString model.lastPressTime),
    Flock.view model
  ]
