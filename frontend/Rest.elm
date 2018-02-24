module Rest exposing (..)

import Model exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
--elm-package install elm-lang/http

send_message: Model -> Cmd Msg
send_message model =
  let
    body =
      [ ("name", Encode.string model.name)
      , ("message", Encode.string model.message)
      ]
      |> Encode.object
      |> Http.jsonBody

    return_int_decoder = Decode.map (\i -> i)
      (Decode.field "return_int" Decode.int)
  in
    Http.send SendMessageReturn (Http.post "/post_message" (body) return_int_decoder)

get_messages: Model -> Cmd Msg
get_messages model =
  let
    body =
      [("last_message", Encode.int (List.length model.messages))]
      |> Encode.object
      |> Http.jsonBody

    message_decoder: Decode.Decoder Message
    message_decoder = Decode.map2 Message
      (Decode.field "name" Decode.string)
      (Decode.field "message" Decode.string)

    return_incomming_messages_decoder: Decode.Decoder IncommingMessages
    return_incomming_messages_decoder = Decode.map2 IncommingMessages
      (Decode.field "last_message" Decode.int)
      (Decode.field "new_messages" (Decode.list message_decoder))
  in
    Http.send GetMessagesReturn (Http.post "/get_messages" (body) return_incomming_messages_decoder)