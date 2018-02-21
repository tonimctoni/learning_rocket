module Rest exposing (..)

import Model exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
--elm-package install elm-lang/http

send_data: Model -> Cmd Msg
send_data model =
  let
    body =
      [ ("name", Encode.string model.name)
      , ("nick", Encode.string model.nick)
      , ("password", Encode.string model.password)
      ]
      |> Encode.object
      |> Http.jsonBody

    return_string_decoder = Decode.map ReturnString
      (Decode.field "return_string" Decode.string)
  in
    Http.send SendDataReturn (Http.post "/receive_data" (body) return_string_decoder)