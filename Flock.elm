module Flock where
--▲▼◀▶
import Html exposing (pre, text, Html)

type Way = Top | Right | Bottom | Left

flock : Way -> Html
flock way =
  let
    chars =
      case way of
        Top -> """
>
  >
     >
  >
>
"""
        Right -> """
>
  >
     >
  >
>
"""
        Bottom -> """
>
  >
     >
  >
>
"""
        Left -> """
>
  >
     >
  >
>
"""
  in
    pre [] [ text chars ]
