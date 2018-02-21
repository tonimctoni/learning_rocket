#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;

use std::io;
use std::path::{Path, PathBuf};
use rocket::response::NamedFile;
use rocket_contrib::{Json};

#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("frontend/index.html")
}

// #[get("/favicon.ico")]
// fn favicon() -> io::Result<NamedFile> {
//     NamedFile::open("resources/favicon.ico")
// }

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
fn post_message(message: Json<Message>) -> Json{
    println!("{:?}", message);
    Json(json!({
        "return_string": "value"
    }))
}

fn main() {
    rocket::ignite().mount("/", routes![index, post_message, files]).launch();
}