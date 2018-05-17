module StyleElements exposing (main)

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Task
import Window


type Msg
    = WindowSize Window.Size


main : Program Never Model Msg
main =
    Html.program
        { init = ( { height = 0, width = 0 }, Window.size |> Task.perform WindowSize )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


view : Model -> Html Msg
view model =
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
        navbar model


greeting : Element Msg
greeting =
    Element.text "Hello Agile and Beyond!"
        |> Element.el [ Element.centerX, Element.alignTop, Element.padding 20, Font.size 80 ]


navbar : Model -> Element Msg
navbar model =
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


links : Element Msg
links =
    Element.row [ width shrink, Element.spacing 10 ]
        [ Element.link [] { url = "", label = Element.text "About" }
        , Element.link [] { url = "", label = Element.text "Contact" }
        , Element.link [] { url = "", label = Element.text "Testimonials" }
        ]


avatar : Element Msg
avatar =
    Element.image
        [ width (px 50) ]
        { src = "/avatar.jpeg", description = "avatar" }


elmLogo : Element Msg
elmLogo =
    -- Element.Input.text [ Element.width (px 500), Font.color darkCharcoal ]
    --     { onChange = Nothing
    --     , text = ""
    --     , placeholder = Just <| Element.Input.placeholder [ Font.color darkCharcoal ] (Element.text "")
    --     , label = Element.Input.labelLeft [] Element.none
    --     }
    Element.image [ width (px 50) ] { src = "/elm.png", description = "elm logo" }


type alias Model =
    Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes WindowSize
