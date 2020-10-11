open Express
open Js.Promise

module Todos = {
  let getAll = PromiseMiddleware.from((_next, req, rep) => {
    let queryDict = Request.query(req)

    switch queryDict->Js.Dict.get("completed") {
    | Some(c) =>
      switch c->Json.Decode.string->bool_of_string_opt {
      | Some(cfilter) => DataAccess.Todos.getByCompletness(cfilter)
      | None => DataAccess.Todos.getAll()
      }
    | None => DataAccess.Todos.getAll()
    } |> then_(todos => {
      rep
      |> Response.setHeader("Status", "200")
      |> Response.sendJson(todos->Model.Todos.toJson)
      |> resolve
    })
  })

  let get = PromiseMiddleware.from((_next, req, rep) =>
    switch Request.params(req)->Js.Dict.get("id") {
    | None => rep |> Response.sendStatus(BadRequest) |> Js.Promise.resolve
    | Some(id) => id->Json.Decode.string |> DataAccess.Todos.getById |> then_(todoJson => {
        rep |> Response.setHeader("Status", "200") |> Response.sendJson(todoJson) |> resolve
      })
    }
  )

  let update = PromiseMiddleware.from((_next, req, rep) =>
    switch Request.params(req)->Js.Dict.get("id") {
    | None => reject(Failure("INVALID MESSAGE"))
    | Some(id) =>
      switch Request.bodyJSON(req) {
      | None => reject(Failure("INVALID MESSAGE"))
      | Some(reqJson) =>
        switch (
          reqJson |> Json.Decode.field("MESSAGE", Json.Decode.optional(Json.Decode.string)),
          reqJson |> Json.Decode.field("completed", Json.Decode.optional(Json.Decode.bool)),
        ) {
        | exception e => reject(e)
        | (Some(msg), Some(isCompleted)) =>
          DataAccess.Todos.update(Json.Decode.string(id), msg, isCompleted)
        | _ => reject(Failure("INVALID MESSAGE"))
        }
      }
    }
    |> then_(() => {
      rep
      |> Response.setHeader("Status", "200")
      |> Response.sendJson(Json.Encode.object_(list{("text", Json.Encode.string("Updated todo"))}))
      |> resolve
    })
    |> catch(err => {
      Js.log(err)

      rep
      |> Response.setHeader("Status", "400")
      |> Response.sendJson(
        Json.Encode.object_(list{
          ("error", Json.Encode.string("INVALID REQUEST OR MISSING MESSAGE FIELD")),
        }),
      )
      |> resolve
    })
  )

  let create = PromiseMiddleware.from((_next, req, rep) =>
    switch Request.bodyJSON(req) {
    | None => reject(Failure("INVALID REQUEST"))
    | Some(reqJson) =>
      switch reqJson |> Json.Decode.field("MESSAGE", Json.Decode.optional(Json.Decode.string)) {
      | exception e => reject(e)
      | None => reject(Failure("INVALID MESSAGE"))
      | Some(msg) => DataAccess.Todos.create(msg)
      }
    }
    |> then_(() => {
      rep
      |> Response.setHeader("Status", "201")
      |> Response.sendJson(Json.Encode.object_(list{("text", Json.Encode.string("Created todo"))}))
      |> resolve
    })
    |> catch(err => {
      Js.log(err)
      rep
      |> Response.setHeader("Status", "400")
      |> Response.sendJson(
        Json.Encode.object_(list{
          ("error", Json.Encode.string("INVALID REQUEST OR MISSING MESSAGE FIELD")),
        }),
      )
      |> resolve
    })
  )
}

let welcome = Middleware.from((_next, _req) => {
  Json.Encode.object_(list{
    ("text", Json.Encode.string("Welcome to Yet Antother Todo api")),
  }) |> Response.sendJson
})

let logRequest = Middleware.from((next, req) => {
  Request.ip(req) ++ " " ++ Request.methodRaw(req) ++ " ressource " ++ Request.path(req)
    |> Logger.info
  next(Next.middleware)
})

let badRessource = Middleware.from((_next, _req, rep) => rep |> Response.sendStatus(NotFound))
