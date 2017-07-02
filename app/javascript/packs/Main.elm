module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Navigation
import Json.Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)


-- MODEL


type alias Model =
    { boyVotes : Int
    , girlVotes : Int
    , totalVotes : Int
    , boyPercentage : String
    , girlPercentage : String
    , pathname : String
    }


voteDecoder : Decoder Model
voteDecoder =
    decode Model
        |> required "boy_votes" int
        |> required "girl_votes" int
        |> hardcoded 0
        |> hardcoded "0"
        |> hardcoded "0"
        |> hardcoded ""


model : Model
model =
    Model 0 0 0 "0" "0" ""


recalculateTotalVotes : Model -> Model
recalculateTotalVotes ({ girlVotes, boyVotes } as model) =
    { model | totalVotes = girlVotes + boyVotes }


empty : Http.Body
empty =
    Http.emptyBody


addGirlVote : Model -> Cmd Message
addGirlVote model =
    let
        url =
            voteUrl model ++ "/girl"
    in
        Http.send (Recalc) (Http.post url empty voteDecoder)


addBoyVote : Model -> Cmd Message
addBoyVote model =
    let
        url =
            voteUrl model ++ "/boy"
    in
        Http.send (Recalc) (Http.post url empty voteDecoder)


initialVotes : Model -> Cmd Message
initialVotes model =
    let
        url =
            voteUrl model ++ "/votes"
    in
        Http.send (Recalc) (Http.post url empty voteDecoder)


voteUrl : Model -> String
voteUrl model =
    model.pathname


calculatePercentage : Model -> Model
calculatePercentage ({ boyVotes, girlVotes, totalVotes } as model) =
    { model
        | boyPercentage =
            if boyVotes == 0 then
                "0"
            else
                toString (round (toFloat (model.boyVotes) / toFloat (model.totalVotes) * 100))
        , girlPercentage =
            if girlVotes == 0 then
                "0"
            else
                toString (round (toFloat (model.girlVotes) / toFloat (model.totalVotes) * 100))
    }



-- INIT


init : Navigation.Location -> ( Model, Cmd Message )
init location =
    ( { model | pathname = location.pathname }, initialVotes { model | pathname = location.pathname } )



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
    | SetLocation Navigation.Location



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        BoyVote ->
            ( model, addBoyVote model )

        GirlVote ->
            ( model, addGirlVote model )

        Recalc (Ok newModel) ->
            ( calculatePercentage (recalculateTotalVotes ({ model | boyVotes = newModel.boyVotes, girlVotes = newModel.girlVotes })), Cmd.none )

        Recalc (Err _) ->
            model ! []

        SetLocation location ->
            ( { model | pathname = location.pathname }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Message
main =
    Navigation.program SetLocation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
