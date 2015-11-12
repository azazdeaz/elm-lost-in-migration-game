module Types where

import Time exposing (Time)

type Screen = Menu | Game | HowTo

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | SetLastPressTime Int
  | AnswerTop Time
  | AnswerRight Time
  | AnswerBottom Time
  | AnswerLeft Time
