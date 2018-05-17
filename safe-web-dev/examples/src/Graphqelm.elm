module Graphqelm exposing (main)

import Graphqelm.Document as Document
import Graphqelm.Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent, Null, Present))
import Graphqelm.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Html exposing (div, h1, p, pre, text)
import RemoteData exposing (RemoteData)
import Swapi.Enum.Episode as Episode exposing (Episode)
import Swapi.Interface
import Swapi.Interface.Character as Character
import Swapi.Query as Query


type alias Response =
    { hero : Character
    }


type alias Character =
    { details : Maybe Never
    , name : String
    }


heroSelection : SelectionSet Character Swapi.Interface.Character
heroSelection =
    Character.selection Character []
        |> with Character.name


query : SelectionSet Response RootQuery
query =
    Query.selection Response
        |> with heroName


heroName : Graphqelm.Field.Field Character RootQuery
heroName =
    Query.hero (\optionals -> { optionals | episode = Present Episode.Jedi }) heroSelection


makeRequest : Cmd Msg
makeRequest =
    query
        -- |> Graphqelm.Http.queryRequest "https://graphqelm.herokuapp.com"
        |> Graphqelm.Http.queryRequest "http://0.0.0.0:4000"
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotResponse)


type Msg
    = GotResponse Model


type alias Model =
    RemoteData (Graphqelm.Http.Error Response) Response


init : ( Model, Cmd Msg )
init =
    ( RemoteData.Loading
    , makeRequest
    )


view : Model -> Html.Html Msg
view model =
    div []
        [ div []
            [ h1 [] [ text "Generated Query" ]
            , pre [] [ text (Document.serializeQuery query) ]
            ]
        , div []
            [ h1 [] [ text "Response" ]
            , model |> toString |> text
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
