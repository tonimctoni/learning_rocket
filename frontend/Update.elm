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

handle_incomming_messages: Model -> IncommingMessages -> Model
handle_incomming_messages model incomming_messages =
  if incomming_messages.last_message==List.length model.messages then
    {model | messages=List.append incomming_messages.messages model.messages}
  else
    model

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetName s -> ({model | name=s}, Cmd.none)
    SetMessage s -> ({model | message=s}, Cmd.none)
    OkName -> (choose_name model, get_messages model)
    GoToChooseName -> ({model | site=ChooseName, status_string="", name=""}, Cmd.none)
    SendMessage -> (model, send_message model)
    SendMessageReturn (Ok _) -> ({model | message=""}, get_messages model)
    SendMessageReturn (Err err) -> ({model | status_string="SendMessage Error: "++(http_err_to_string err)}, Cmd.none)
    TimeToCheckForMessages _ -> (model, get_messages model)
    GetMessagesReturn (Ok incomming_messages) -> (handle_incomming_messages model incomming_messages, Cmd.none)
    GetMessagesReturn (Err err) -> ({model | status_string="GetMessages Error: "++(http_err_to_string err)}, Cmd.none)