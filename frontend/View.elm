module View exposing (view)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Decode

onEnter : Msg -> Attribute Msg
onEnter msg =
  let
    isEnter code =
      if code == 13 then
        Decode.succeed msg
      else
        Decode.fail "not ENTER"
  in
    on "keydown" (Decode.andThen isEnter keyCode)

message_input: Model -> Html Msg
message_input model =
  div [style [("padding", "10pt")]]
  [ p [style [("font-weight", "bold"), ("color", "green")]] [text (model.name++": "), input [style [("width", "75%")], type_ "text", placeholder "Message", onInput SetMessage, onEnter SendMessage, value model.message] []]
  , button [onClick SendMessage, disabled (String.length model.message<1)] [text "Send"]
  ]

format_message: Message -> Html Msg
format_message message =
  div [style [("padding", "2pt"), ("color", "magenta")]] [node "b" [] [text (message.name++": ")], text message.message]

message_list_div: Model -> Html Msg
message_list_div model =
  div
  [style [("background-color", "rgba(123, 123, 123, 0.5)"), ("width", "65%"), ("margin", "20pt"), ("border-radius", "6px")]]
  (List.map format_message model.messages)

chat_div: Model -> Html Msg
chat_div model =
  div []
  [ p [style [("font-weight", "bold"), ("color", "red")]] [text model.status_string]
  , button [style [("left", "4cm")], onClick GoToChooseName] [text "Change name"]
  , text model.status_string
  , message_input model
  , message_list_div model
  ]

choose_name_div: Model -> Html Msg
choose_name_div model =
  div [class "choose_name_form_container_class"]
  [ h1 [class "choose_name_form_title_class"] [text "Choose Name"]
  , input [class "choose_name_input_class", type_ "text", placeholder "Name", onInput SetName, onEnter OkName] []
  , br [] []
  , div [] [button [onClick OkName] [text "Ok"]]
  , if String.length model.status_string == 0 then br [] [] else p [style [("font-weight", "bold"), ("color", "red")]] [text model.status_string]
  ]

view: Model -> Html Msg
view model =
  div []
  [ node "link" [ rel "stylesheet", href "/mycss.css"] []
  , case model.site of
      ChooseName -> choose_name_div model
      Chat -> chat_div model
  ]