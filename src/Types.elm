module Types where

import Time exposing (Time)
import Random

type alias Keys = { x:Int, y:Int }

type alias Model =
  { screen: Screen
  , seed: Random.Seed
  , goodDirection: Direction
  , points: Int
  }

type Screen = Menu | Game | HowTo

type Direction = Up | Right | Left | Down

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetPoints
  | Answer Direction Time
