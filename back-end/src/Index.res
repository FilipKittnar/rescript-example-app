open Express

let app = express()

let port = 3000

app->App.get(~path="/person", PromiseMiddleware.from((_, _, response) => {
    open Js.Promise
    Database.database->ResPgPromise.any("select * from person") |> then_(result => {
      let json = Js.Dict.empty()
      json->Js.Dict.set("persons", result->Js.Json.array)
      resolve(
        response
        |> Response.status(Response.StatusCode.Ok)
        |> Response.sendJson(json->Js.Json.object_),
      )
    }) |> catch(error => {
      Js.log2("Failed to get Persons from data source", error)
      resolve(response |> Response.sendStatus(Response.StatusCode.InternalServerError))
    })
  }))

app->App.post(~path="/person", PromiseMiddleware.from((_, request, response) => {
    open Js.Promise

    let body = request->Request.bodyJSON

    switch body {
    | Some(body) =>
      Database.database->ResPgPromise.none(
        "insert into person (id, name, age, active) values(${id}, ${name}, ${age}, ${active})",
        // TODO: Generate ID and use other values
        switch body->Js.Json.decodeObject {
        | Some(decoded) => decoded
        // TODO: This needs to return 400
        | None => Js.Dict.empty()
        },
      )
      |> then_(() => {
        resolve(response |> Response.sendStatus(Response.StatusCode.Ok))
      })
      |> catch(error => {
        Js.log2("Failed to insert new Person to data source", error)
        resolve(response |> Response.sendStatus(Response.StatusCode.InternalServerError))
      })
    | None =>
      Js.log2("Got no Person in body", body)
      resolve(response |> Response.sendStatus(Response.StatusCode.BadRequest))
    }
  }))

app->App.listen(
  ~port,
  ~onListen=e => {
    switch e {
    | exception Js.Exn.Error(e) =>
      e->Js.log
      Node.Process.exit(1)
    | _ => {
        Liquibase.update()
        (`Listening at http://localhost:${port->string_of_int}`)->Js.log
      }
    }
  },
  (),
)
