module Update exposing (update)

import Rest exposing (..)
import Model exposing (..)
import Http

choose_name: Model -> Model
choose_name model =
  if String.length model.name>0 && String.length model.name<16 then
    {model | site=Chat, status_string=""}
  else
    {model | status_string="Name must have between 1 and 15 characters."}

http_err_to_string: Http.Error -> String
http_err_to_string err =
  case err of
    Http.BadUrl s -> "BadUrl("++s++")"
    Http.Timeout -> "Timeout"
    Http.NetworkError -> "NetworkError"
    Http.BadStatus _ -> "BadStatus"
    Http.BadPayload s _ -> "BadPayload("++s++")"

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetName s -> ({model | name=s}, Cmd.none)
    SetMessage s -> ({model | message=s}, Cmd.none)
    OkName -> (choose_name model, Cmd.none)
    GoToChooseName -> ({model | site=ChooseName, status_string="", name=""}, Cmd.none)
    SendMessage -> (model, send_message model)
    SendMessageReturn _ -> ({model | message=""}, Cmd.none)
    --SetNick s -> ({model | nick=s, status_string="Nick set"}, Cmd.none)
    --SetPassword s -> ({model | password=s, status_string="Password set"}, Cmd.none)
    --SendData -> ({model | status_string="Data sent"}, send_data model)
    --SendDataReturn (Ok return_string) -> ({model | status_string="Data sent, received: "++return_string.return_string}, Cmd.none)
    --SendDataReturn (Err err) -> case err of
    --  Http.BadUrl s -> ({model | status_string="Data sent, BadUrl received: "++s}, Cmd.none)
    --  Http.Timeout -> ({model | status_string="Data sent, Timeout received"}, Cmd.none)
    --  Http.NetworkError -> ({model | status_string="Data sent, NetworkError received"}, Cmd.none)
    --  Http.BadStatus _ -> ({model | status_string="Data sent, BadStatus received"}, Cmd.none)
    --  Http.BadPayload s _ -> ({model | status_string="Data sent, BadPayload received: "++s}, Cmd.none)