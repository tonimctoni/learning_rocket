module Model exposing (..)

import Http
import Time exposing (Time)

type Site
  = ChooseName
  | Chat

type alias Message =
  { name: String
  , message: String
  }

type Msg
  = SetName String
  | OkName
  | SetMessage String
  | GoToChooseName
  | SendMessage
  | SendMessageReturn (Result Http.Error Int)
  | TimeToCheckForMessages Time
  | GetMessagesReturn (Result Http.Error (List Message))

type alias Model =
  { name: String
  , message: String
  , messages: List Message
  , status_string: String
  , site: Site
  }

init: (Model, Cmd Msg)
init = (Model "" "" [] "" ChooseName, Cmd.none)