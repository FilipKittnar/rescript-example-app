open Express

let app = express()

let port = 3000

app->App.get(~path="/", Middleware.from((_, _) => {
    open Js.Promise
    Database.database->ResPgPromise.any("select * from person") |> then_(result => {
      Js.log2("Persons from DB:", result)
      resolve()
    }) |> catch(error => {
      Js.log2("Failed to get Persons from DB:", error)
      resolve()
    }) |> ignore

    let json = Js.Dict.empty()
    Js.Dict.set(json, "success", Js.Json.boolean(true))
    Response.sendJson(Js.Json.object_(json))
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
