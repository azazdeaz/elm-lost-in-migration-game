module Flock where

import Html exposing (div, text, Html)
import Html.Attributes exposing (style)
import Array
import Random
import Random.Array exposing (sample)
import Graphics.Element exposing (show)
import Maybe exposing (withDefault)
import Bird
import Types exposing (..)

type Field = Empty | Up | Right | Down | Left

type Markup = I | O | X
type alias MarkupLine = (Markup,Markup,Markup,Markup,Markup)
type alias MarkupForm = (MarkupLine,MarkupLine,MarkupLine,MarkupLine,MarkupLine)
type alias FieldLine = (Field,Field,Field,Field,Field)
type alias FieldForm = (FieldLine,FieldLine,FieldLine,FieldLine,FieldLine)

crossForm : MarkupForm
crossForm =
  (
    (I,I,I,I,I),
    (I,I,O,I,I),
    (I,O,X,O,I),
    (I,I,O,I,I),
    (I,I,I,I,I)
  )

upForm : MarkupForm
upForm =
  (
    (I,I,I,I,I),
    (I,I,X,I,I),
    (I,O,I,O,I),
    (O,I,I,I,O),
    (I,I,I,I,I)
  )

rightForm : MarkupForm
rightForm =
  (
    (I,O,I,I,I),
    (I,I,O,I,I),
    (I,I,I,X,I),
    (I,I,O,I,I),
    (I,O,I,I,I)
  )

downForm : MarkupForm
downForm =
  (
    (I,I,I,I,I),
    (O,I,I,I,O),
    (I,O,I,O,I),
    (I,I,X,I,I),
    (I,I,I,I,I)
  )

leftForm : MarkupForm
leftForm =
  (
    (I,I,I,O,I),
    (I,I,O,I,I),
    (I,X,I,I,I),
    (I,I,O,I,I),
    (I,I,I,O,I)
  )

verticalForm : MarkupForm
verticalForm =
  (
    (I,I,O,I,I),
    (I,I,O,I,I),
    (I,I,X,I,I),
    (I,I,O,I,I),
    (I,I,O,I,I)
  )

horisontalForm : MarkupForm
horisontalForm =
  (
    (I,I,I,I,I),
    (I,I,I,I,I),
    (O,O,X,O,O),
    (I,I,I,I,I),
    (I,I,I,I,I)
  )

forms : List MarkupForm
forms =
  [
    crossForm,
    upForm,
    rightForm,
    downForm,
    leftForm,
    verticalForm,
    horisontalForm
  ]

markupToField : Markup -> Field -> Field -> Field
markupToField markup oField xField =
  case markup of
    I -> Empty
    O -> oField
    X -> xField

markupFormToFieldForm markupForm oField xField =
  let
    (
      (a1, b1, c1, d1, e1),
      (a2, b2, c2, d2, e2),
      (a3, b3, c3, d3, e3),
      (a4, b4, c4, d4, e4),
      (a5, b5, c5, d5, e5)
    ) = markupForm

    f markup =
      markupToField markup oField xField
  in
    (
      (f a1, f b1, f c1, f d1, f e1),
      (f a2, f b2, f c2, f d2, f e2),
      (f a3, f b3, f c3, f d3, f e3),
      (f a4, f b4, f c4, f d4, f e4),
      (f a5, f b5, f c5, f d5, f e5)
    )

getRandomFlock : Int -> FieldForm
getRandomFlock time =
  let
    seed = Random.initialSeed time
    (maybeForm, seed') = (sample seed (Array.fromList forms))
    ways = Array.fromList [Up, Left, Right, Down]
    (maybeDirection, seed'') = sample seed' ways
    (maybeMiddleDirection, seed''') = sample seed'' ways
    form = withDefault crossForm maybeForm
    direction = withDefault Left maybeDirection
    middleDirection = withDefault Left maybeMiddleDirection
  in
    markupFormToFieldForm form direction middleDirection

flockView fieldForm =
  let
    (
      (a1, b1, c1, d1, e1),
      (a2, b2, c2, d2, e2),
      (a3, b3, c3, d3, e3),
      (a4, b4, c4, d4, e4),
      (a5, b5, c5, d5, e5)
    ) = fieldForm

    f x y field =
      let
        rotation =
          case field of
            Up
              -> "-90"
            Right
              -> "0"
            Down
              -> "90"
            Left
              -> "180"
            Empty
              -> ""
      in
        if field == Empty
        then
          text ""
        else
          Bird.bird 21 x y rotation
  in
    div
      [ style
        [ ("position", "absolute")
        ]
      ]
      [ (f 0 0 a1), (f 1 0 b1), (f 2 0 c1), (f 3 0 d1), (f 4 0 e1),
        (f 0 1 a2), (f 1 1 b2), (f 2 1 c2), (f 3 1 d2), (f 4 1 e2),
        (f 0 2 a3), (f 1 2 b3), (f 2 2 c3), (f 3 2 d3), (f 4 2 e3),
        (f 0 3 a4), (f 1 3 b4), (f 2 3 c4), (f 3 3 d4), (f 4 3 e4),
        (f 0 4 a5), (f 1 4 b5), (f 2 4 c5), (f 3 4 d5), (f 4 4 e5)
      ]

view : Model -> Html
view model =
  flockView (getRandomFlock model.lastPressTime)
