module Model exposing (..)

import Http
import Time exposing (Time)

type Msg
  = SetName String
  | SetMessage String
  | OkName
  | GoToChooseName
  | SendMessage
  | SendMessageReturn (Result Http.Error Int)
  | TimeToCheckForMessages Time
  --| GetMessages
  | GetMessagesReturn (Result Http.Error (List String))

type Site
  = ChooseName
  | Chat

type alias Model =
  { name: String
  , message: String
  , messages: List String
  , status_string: String
  , site: Site
  }

init: (Model, Cmd Msg)
init = (Model "" "" [] "" ChooseName, Cmd.none)