#![feature(plugin)]
#![plugin(rocket_codegen)]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;
extern crate serde;

use std::io;
use rocket::response::NamedFile;
use rocket_contrib::{Json};

#[get("/")]
fn index() -> io::Result<NamedFile> {
    NamedFile::open("frontend/index.html")
}

#[derive(Serialize, Deserialize, Debug)]
struct Data {
    name: String,
    nick: String,
    password: String
}

#[post("/receive_data", format = "application/json", data = "<data>")]
fn receive_data(data: Json<Data>) -> Json{
    println!("{:?}", data);
    Json(json!({
        "return_string": "value"
    }))
}

fn main() {
    rocket::ignite().mount("/", routes![index, receive_data]).launch();
}