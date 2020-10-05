open Express

let app = express()

let port = 3000

app->App.get(~path="/person", PromiseMiddleware.from((_, _, res) => {
    open Js.Promise
    Database.database->ResPgPromise.any("select * from person") |> then_(result => {
      let json = Js.Dict.empty()
      Js.Dict.set(json, "persons", Js.Json.array(result))
      resolve(res |> Response.status(Response.StatusCode.Ok) |> Response.sendJson(Js.Json.object_(json)))
    }) |> catch(error => {
      Js.log2("Failed to get Persons from DB", error)
      resolve(res |> Response.sendStatus(Response.StatusCode.InternalServerError))
    })
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
