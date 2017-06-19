module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


-- MODEL


type alias Model =
    { boyVotes : Int
    , girlVotes : Int
    , totalVotes : Int
    , boyPercentage : String
    , girlPercentage : String
    }


model : Model
model =
    Model 0 0 0 "0" "0"


recalulateTotalVotes : Model -> Model
recalulateTotalVotes ({ girlVotes, boyVotes } as model) =
    { model | totalVotes = girlVotes + boyVotes }


addGirlVote : Model -> Model
addGirlVote ({ girlVotes } as model) =
    recalulateTotalVotes ({ model | girlVotes = model.girlVotes + 1 })


addBoyVote : Model -> Model
addBoyVote ({ boyVotes } as model) =
    recalulateTotalVotes ({ model | boyVotes = model.boyVotes + 1 })


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



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        BoyVote ->
            ( calculatePercentage (addBoyVote model), Cmd.none )

        GirlVote ->
            ( calculatePercentage (addGirlVote model), Cmd.none )



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
