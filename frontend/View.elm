module View exposing (view)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

message_input: Model -> Html Msg
message_input model =
  div [style [("padding", "10pt")]]
  [ p [style [("font-weight", "bold"), ("color", "green")]] [text (model.name++": "), input [style [("width", "75%")], type_ "text", placeholder "Message", onInput SetMessage] []]
  , button [onClick SendMessage, disabled (String.length model.message<1)] [text "Send"]
  ]

message_list_div: Model -> Html Msg
message_list_div model =
  div
  [style [("background-color", "rgba(123, 123, 123, 0.5)"), ("width", "65%"), ("margin", "20pt"), ("border-radius", "6px")]]
  (List.map (\s -> div [style [("padding", "2pt"), ("color", "magenta")]] [text s]) model.messages)

chat_div: Model -> Html Msg
chat_div model =
  div []
  [ button [style [("position", "fixed"), ("left", "4cm")], onClick GoToChooseName] [text "Change name"]
  , message_input model
  , message_list_div model
  ]

choose_name_div: Model -> Html Msg
choose_name_div model =
  div [class "choose_name_form_container_class"]
  [ h1 [class "choose_name_form_title_class"] [text "Choose Name"]
  , input [class "choose_name_input_class", type_ "text", placeholder "Name", onInput SetName] []
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