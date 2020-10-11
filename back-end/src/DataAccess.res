open Js.Promise

module Todos = {
  let getAll: unit => Js.Promise.t<Model.Todos.t> = () => {
    Database.database->ResPgPromise.any("select * from todo") |> then_(result => {
      let todos = Model.Todos.fromJson(result->Js.Json.array)
      let todoObjects = todos->Belt.List.map(todo => {
        Model.Todo.make(
          Model.Todo.getId(todo),
          Model.Todo.getDescription(todo),
          Model.Todo.isCompleted(todo),
        )
      })
      resolve(todoObjects)
    }) |> catch(error => {
      Js.log2("Failed to get TODOs from data source", error)
      resolve(Js.Json.null->Model.Todos.fromJson)
    })
  }

  let getByCompletness = cfilter =>
    make((~resolve, ~reject) => resolve(. Js.Json.null->Model.Todos.fromJson))

  let getById = id => make((~resolve, ~reject) => resolve(. Js.Json.null))

  let update = (id, description, completed) => make((~resolve, ~reject) => ())

  let create = description => make((~resolve, ~reject) => ())
}
