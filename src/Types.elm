module Types where

import Time exposing (Time)

type alias Keys = { x:Int, y:Int }

type alias Model =
  { screen: Screen
  , lastPressTime: Int
  , points: Int
  }

type Screen = Menu | Game | HowTo

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | AnswerTop Time
  | AnswerRight Time
  | AnswerBottom Time
  | AnswerLeft Time
