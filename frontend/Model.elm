module Model exposing (..)

import Http

type Msg
  = SetName String
  | SetMessage String
  | OkName
  | GoToChooseName
  | SendMessage
  | SendMessageReturn (Result Http.Error Int)

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
init = (Model "" "" ["A","B","C"] "" ChooseName, Cmd.none)