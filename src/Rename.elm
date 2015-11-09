module Action where
import Main exposing (Secreen)

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | SetLastPressTime Int
