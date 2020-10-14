let onListen = e =>
  switch e {
  | exception Js.Exn.Error(e) =>
    switch Js.Exn.message(e) {
    | None => "UNKNOWN ERROR"
    | Some(msg) => msg
    }->Logger.error
    Node.Process.exit(1)
  | _ => {
      Liquibase.update()
      "Listening at http://localhost:8080"->Logger.info
    }
  }

let server = Express.App.listen(Api.app, ~port=8080, ~onListen, ())
