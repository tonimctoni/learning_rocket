module View exposing (..)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

inputs_div: Html Msg
inputs_div =
  div []
  [ input [type_ "text", placeholder "Name", onInput SetName] []
  , br [] []
  , input [type_ "text", placeholder "Nick", onInput SetNick] []
  , br [] []
  , input [type_ "password", placeholder "Password", onInput SetPassword] []
  ]

show_data_div: Model -> Html Msg
show_data_div model =
  div []
  [ text model.name
  , br [] []
  , text model.nick
  , br [] []
  , text model.password
  ]

show_status_div: Model -> Html Msg
show_status_div model =
  div []
  [ text ("Status: "++model.status_string)
  ]

view: Model -> Html Msg
view model =
  div []
  [ inputs_div
  , button [onClick SendData] [text "Send Data"]
  , show_data_div model
  , show_status_div model
  ]