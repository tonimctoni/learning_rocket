#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;

use std::io;
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};
use rocket::response::NamedFile;
use rocket::State;
use rocket_contrib::{Json};

#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("frontend/index.html")
}

#[get("/<file..>")]
fn files(file: PathBuf) -> Option<NamedFile> {
    NamedFile::open(Path::new("resources/").join(file)).ok()
}

#[derive(Serialize, Deserialize, Debug)]
struct Message {
    name: String,
    message: String,
}

#[post("/post_message", format = "application/json", data = "<message>")]
fn post_message(messages: State<Arc<Mutex<Vec<String>>>>, message: Json<Message>) -> Json{
    let Message{name, message}=message.into_inner();
    {
        let mut messages=match messages.lock() {
            Ok(messages) => messages,
            Err(e) => {
                eprintln!("Error: {:?}", e);
                return Json(json!({
                    "return_int": 1
                }))
            },
        };
        messages.push(format!("{}: {}", name, message));
    }
    Json(json!({
        "return_int": 0
    }))
}

#[derive(Serialize, Deserialize, Debug)]
struct LastMessage {
    last_message: usize,
}

#[post("/get_messages", format = "application/json", data = "<last_message>")]
fn get_messages(messages: State<Arc<Mutex<Vec<String>>>>, last_message: Json<LastMessage>) -> Json{
    const EMPTY_STRING_ARRAY: [String;0] = [];
    let LastMessage{last_message}=last_message.into_inner();

    let messages=match messages.lock() {
        Ok(messages) => messages,
        Err(e) => {
            eprintln!("Error: {:?}", e);
            return Json(json!({
                "new_messages": EMPTY_STRING_ARRAY
            }))
        },
    };

    if messages.len()>last_message{
        Json(json!({
            "new_messages": messages[last_message..].iter().rev().collect::<Vec<_>>()
        }))
    } else {
        Json(json!({
            "new_messages": EMPTY_STRING_ARRAY
        }))
    }
}

fn main() {
    let messages: Arc<Mutex<Vec<String>>>=Arc::new(Mutex::new(Vec::new()));
    rocket::ignite()
    .mount("/", routes![index, files, post_message, get_messages])
    .manage(messages)
    .launch();
}