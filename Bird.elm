module Bird where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Attributes

bird : Float -> Float -> Float -> String -> Svg
bird sizeNumber x y rotation=
  let
    size times = " " ++ toString (sizeNumber * times)
  in
    svg
      [ width (size 1),
        height (size 1),
        Html.Attributes.style
          [ ( "transform",
              "translateX(" ++ size x ++"px)"
              ++ " translateY(" ++ size y ++"px)"
              ++ " rotate(" ++ rotation ++ "deg)"
            ),
            ("position", "absolute"),
            ("left", "0px"),
            ("top", "0px")
          ]
      ]
      [ Svg.path
          [ d (
              "M" ++ size 0.8 ++ size 0.5
              ++ " L" ++ size 0.2 ++ size 0
              ++ " L" ++ size 0.5 ++ size 0.5
              ++ " L" ++ size 0.2 ++ size 1
              ++ " Z"
              )
          ]
          []
       ]

main : Svg
main =
  bird 64 1 2 "180"
