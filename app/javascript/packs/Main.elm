module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


-- MODEL


type alias Model =
    { boyVotes : Int
    , girlVotes : Int
    , totalVotes : Int
    , boyPercentage : String
    , girlPercentage : String
    }


voteDecoder : Decoder Model
voteDecoder =
    decode Model
        |> required "boy_votes" int
        |> required "girl_votes" int
        |> hardcoded 0
        |> hardcoded "0"
        |> hardcoded "0"


model : Model
model =
    Model 0 0 0 "0" "0"


recalculateTotalVotes : Model -> Model
recalculateTotalVotes ({ girlVotes, boyVotes } as model) =
    { model | totalVotes = girlVotes + boyVotes }


empty : Http.Body
empty =
    Http.emptyBody


addGirlVote : Cmd Message
addGirlVote =
    let
        url =
            "/girl"
    in
        Http.send (Recalc) (Http.post url empty voteDecoder)


addBoyVote : Cmd Message
addBoyVote =
    let
        url =
            "/boy"
    in
        Http.send (Recalc) (Http.post url empty voteDecoder)


calculatePercentage : Model -> Model
calculatePercentage ({ boyVotes, totalVotes } as model) =
    { model
        | boyPercentage = toString (round (toFloat (model.boyVotes) / toFloat (model.totalVotes) * 100))
        , girlPercentage = toString (round (toFloat (model.girlVotes) / toFloat (model.totalVotes) * 100))
    }



-- INIT


init : ( Model, Cmd Message )
init =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Message
view model =
    -- The inline style is being used for example purposes in order to keep this example simple and
    -- avoid loading additional resources. Use a proper stylesheet when building your own app.
    div []
        [ h1 [] [ text "What is the Gender of the Baby?" ]
        , button [ onClick BoyVote ] [ text "Boy!" ]
        , button [ onClick GirlVote ] [ text "Girl!" ]
        , p [] [ text ("Boy: " ++ toString (model.boyVotes) ++ "     " ++ model.boyPercentage ++ "%") ]
        , p [] [ text ("Girl: " ++ toString (model.girlVotes) ++ "     " ++ model.girlPercentage ++ "%") ]
        , p [] [ text ("Total Votes: " ++ toString (model.totalVotes)) ]
        ]



-- MESSAGE


type Message
    = BoyVote
    | GirlVote
    | Recalc (Result Http.Error Model)



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        BoyVote ->
            ( model, addBoyVote )

        GirlVote ->
            ( model, addGirlVote )

        Recalc (Ok newModel) ->
            ( calculatePercentage (recalculateTotalVotes ({ model | boyVotes = newModel.boyVotes, girlVotes = newModel.girlVotes })), Cmd.none )

        Recalc (Err _) ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Message
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
