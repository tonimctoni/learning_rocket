module Update exposing (..)

import Rest exposing (..)
import Model exposing (..)
import Http

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetName s -> ({model | name=s, status_string="Name set"}, Cmd.none)
    SetNick s -> ({model | nick=s, status_string="Nick set"}, Cmd.none)
    SetPassword s -> ({model | password=s, status_string="Password set"}, Cmd.none)
    SendData -> ({model | status_string="Data sent"}, send_data model)
    SendDataReturn (Ok return_string) -> ({model | status_string="Data sent, received: "++return_string.return_string}, Cmd.none)
    SendDataReturn (Err err) -> case err of
      Http.BadUrl s -> ({model | status_string="Data sent, BadUrl received: "++s}, Cmd.none)
      Http.Timeout -> ({model | status_string="Data sent, Timeout received"}, Cmd.none)
      Http.NetworkError -> ({model | status_string="Data sent, NetworkError received"}, Cmd.none)
      Http.BadStatus _ -> ({model | status_string="Data sent, BadStatus received"}, Cmd.none)
      Http.BadPayload s _ -> ({model | status_string="Data sent, BadPayload received: "++s}, Cmd.none)