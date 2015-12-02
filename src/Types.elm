module Types where

import Time exposing (Time)
import Random

type alias Keys = { x:Int, y:Int }

type alias Model =
  { screen: Screen
  , seed: Random.Seed
  , goodDirection: Direction
  , score: Int
  , gameElapsedTime: Time
  , gameWidth: Int
  , gameHeight: Int
  }

type Screen = Menu | Game | HowTo

type Direction = Up | Right | Left | Down

type Action
  = NoOp
  | Tick Time
  | ChangeScreen Screen
  | ResetScore
  | Answer Direction Time
