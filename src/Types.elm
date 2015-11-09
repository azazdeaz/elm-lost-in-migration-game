module Types where

type Screen = Menu | Game | HowTo

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | SetLastPressTime Int
