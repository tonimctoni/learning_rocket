module Model exposing (..)

import Http

type alias ReturnString =
  { return_string: String
  }

type Msg
  = SetName String
  | SetNick String
  | SetPassword String
  | SendData
  | SendDataReturn (Result Http.Error ReturnString)

type alias Model =
  { name: String
  , nick: String
  , password: String
  , status_string: String
  }

init: (Model, Cmd Msg)
init = (Model "" "" "" "", Cmd.none)