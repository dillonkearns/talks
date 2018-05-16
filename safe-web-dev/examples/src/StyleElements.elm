module StyleElements exposing (main)

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input
import Html exposing (Html)


main : Html msg
main =
    Element.layout
        [ Background.color blue
        , Font.color white
        , Font.size 22
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=EB+Garamond"
                , name = "EB Garamond"
                }
            , Font.sansSerif
            ]
        ]
    <|
        Element.column []
            [ Element.row
                [ height (px 100)
                , width fill
                , Background.color darkCharcoal
                , Element.spaceEvenly
                , padding 20
                ]
                [ Element.text "Style Elements Demo" |> Element.el [ Font.size 30 ]
                , searchBar
                , links
                , avatar
                ]
            ]


links : Element msg
links =
    Element.row [ width (px 100) ]
        [ Element.link [] { url = "asdf", label = Element.text "Pull Requests" }
        ]


avatar : Element msg
avatar =
    Element.text "avatar"


searchBar : Element msg
searchBar =
    Element.Input.text [ Element.width (px 500) ] { onChange = Nothing, text = "", placeholder = Nothing, label = Element.Input.labelLeft [] (Element.text "Search") }



-- el
--     [ width (px 200), height (px 200) ]
--     (text "Hello stylish friend!")
