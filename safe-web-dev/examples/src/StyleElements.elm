module StyleElements exposing (main)

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
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
                [ Element.row
                    [ Element.spacing 10
                    , Element.padding 10
                    , Element.width Element.shrink
                    , Element.mouseOver [ Background.color Color.black ]
                    ]
                    [ Element.text "Style Elements Demo" |> Element.el [ Font.size 30 ]
                    , elmLogo
                    ]
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


elmLogo : Element msg
elmLogo =
    -- Element.Input.text [ Element.width (px 500), Font.color darkCharcoal ]
    --     { onChange = Nothing
    --     , text = ""
    --     , placeholder = Just <| Element.Input.placeholder [ Font.color darkCharcoal ] (Element.text "")
    --     , label = Element.Input.labelLeft [] Element.none
    --     }
    Element.image [ width (px 50) ] { src = "/elm.png", description = "elm logo" }



-- el
--     [ width (px 200), height (px 200) ]
--     (text "Hello stylish friend!")
