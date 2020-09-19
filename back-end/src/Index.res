open Express

let checkProperty = (req, next, property, k, res) => {
  let reqData = Request.asJsonObject(req)
  switch Js.Dict.get(reqData, property) {
  | None => next(Next.route, res)
  | Some(x) =>
    switch Js.Json.decodeBoolean(x) {
    | Some(b) when b => k(res)
    | _ => next(Next.route, res)
    }
  }
}

let checkProperties = (req, next, properties, k, res) => {
  let rec aux = properties =>
    switch properties {
    | list{} => k(res)
    | list{p, ...tl} => checkProperty(req, next, p, _ => aux(tl), res)
    }
  aux(properties)
}

let setProperty = (req, property, res) => {
  let reqData = Request.asJsonObject(req)
  Js.Dict.set(reqData, property, Js.Json.boolean(true))
  res
}

let getDictString = (dict, key) =>
  switch Js.Dict.get(dict, key) {
  | Some(json) => Js.Json.decodeString(json)
  | _ => None
  }

let makeSuccessJson = () => {
  let json = Js.Dict.empty()
  Js.Dict.set(json, "success", Js.Json.boolean(true))
  Js.Json.object_(json)
}

let app = express()

app->App.disable(~name="x-powered-by")

\"@@"(
  App.useOnPath(app, ~path="/"),
  Middleware.from((next, req, res) =>
    res |> setProperty(req, "middleware0") |> next(Next.middleware)
  ),
)

App.useWithMany(
  app,
  [
    Middleware.from((next, req) =>
      checkProperty(req, next, "middleware0", res =>
        res |> setProperty(req, "middleware1") |> next(Next.middleware)
      )
    ),
    Middleware.from((next, req) =>
      checkProperties(req, next, list{"middleware0", "middleware1"}, res =>
        next(Next.middleware, setProperty(req, "middleware2", res))
      )
    ),
  ],
)

\"@@"(App.get(app, ~path="/"), Middleware.from((next, req) => {
    let previousMiddlewares = list{"middleware0", "middleware1", "middleware2"}
    checkProperties(req, next, previousMiddlewares, Response.sendJson(makeSuccessJson()))
  }))

App.postWithMany(app, ~path="/:id/id", [Middleware.from((next, req) => {
      let previousMiddlewares = list{"middleware0", "middleware1", "middleware2"}
      checkProperties(req, next, previousMiddlewares, res =>
        switch getDictString(Request.params(req), "id") {
        | Some("123") => Response.sendJson(makeSuccessJson(), res)
        | _ => next(Next.route, res)
        }
      )
    })])

let router1 = router()

\"@@"(Router.get(router1, ~path="/123"), Middleware.from((_, _) => Response.sendStatus(Created)))

let onListen = e =>
  switch e {
  | exception Js.Exn.Error(e) =>
    Js.log(e)
    Node.Process.exit(1)
  | _ => \"@@"(Js.log, "Listening at http://127.0.0.1:3000")
  }

let server = App.listen(app, ~port=3000, ~onListen, ())
