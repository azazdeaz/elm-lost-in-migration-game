module Types where

import Time exposing (Time)
import Random

type alias Keys = { x:Int, y:Int }

type alias Model =
  { screen: Screen
  , seed: Random.Seed
  , goodDirection: Direction
  , score: Int
  }

type Screen = Menu | Game | HowTo

type Direction = Up | Right | Left | Down

type Action
  = NoOp
  | ChangeScreen Screen
  | ResetScore
  | Answer Direction Time
