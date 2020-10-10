@bs.module("uuid") external uuidv4: unit => string = "v4"

module Todo: {
  type t
  let make: (string, string, bool) => t
  let makeNew: string => t
  let modifyDescription: (string, t) => t
  let complete: t => t
  let uncomplete: t => t
  let getId: t => string
  let getDescription: t => string
  let isCompleted: t => bool
  let fromJson: Js.Json.t => t
  let fromString: string => option<t>
  let toJson: t => Js.Json.t
  let toString: t => string
} = {
  type t = {
    id: string,
    description: string,
    completed: bool,
  }

  let make = (id, description, completed) => {
    id: id,
    description: description,
    completed: completed,
  }
  let makeNew = description => make(uuidv4(), description, false)

  let getId = todo => todo.id
  let getDescription = todo => todo.description
  let isCompleted = todo => todo.completed

  let modifyDescription = (newDesc, todo) => {...todo, description: newDesc}
  let complete = todo => {
    {...todo, completed: true}
  }
  let uncomplete = todo => {
    {...todo, completed: false}
  }

  let bool_of_int = value => value === 1
  let fromJson = json => {
    id: json |> Json.Decode.field("ID", Json.Decode.string),
    description: json |> Json.Decode.field("DESCRIPTION", Json.Decode.string),
    completed: json |> Json.Decode.field("COMPLETED", Json.Decode.int) |> bool_of_int,
  }

  let fromString = jsonString =>
    switch Json.parse(jsonString) {
    | Some(validJson) => Some(fromJson(validJson))
    | None => None
    }

  let toJson = todo =>
    Json.Encode.object_(list{
      ("id", Json.Encode.string(todo.id)),
      ("description", Json.Encode.string(todo.description)),
      ("completed", Json.Encode.bool(todo.completed)),
    })
  let toString = todo => toJson(todo) |> Js.Json.stringify
}

module Todos: {
  type t = list<Todo.t>
  let filterByDescription: (string, t) => t
  let filterByCompletness: (bool, t) => t
  let fromJson: Js.Json.t => t
  let fromString: string => option<t>
  let toJson: t => Js.Json.t
  let toString: t => string
} = {
  type t = list<Todo.t>

  let filterBy: (~description: option<string>, ~completed: option<bool>, t) => t = (
    ~description,
    ~completed,
    todos,
  ) => {
    let descFiltered = switch description {
    | None => todos
    | Some(desc) =>
      List.filter(
        item => Js.String.includes(Js.String.make(desc), Js.String.make(Todo.getDescription(item))),
        todos,
      )
    }

    switch completed {
    | None => descFiltered
    | Some(b) => List.filter(item => Todo.isCompleted(item) === b, descFiltered)
    }
  }

  let filterByDescription = description => filterBy(~description=Some(description), ~completed=None)
  let filterByCompletness = completed => filterBy(~description=None, ~completed=Some(completed))

  let fromJson: Js.Json.t => t = json => json |> Json.Decode.list(Todo.fromJson)

  let fromString = jsonString =>
    switch Json.parse(jsonString) {
    | Some(validJson) => Some(fromJson(validJson))
    | None => None
    }

  let toJson = todos =>
    Array.of_list(todos) |> Array.map(item => Todo.toJson(item)) |> Json.Encode.jsonArray
  let toString = todos => toJson(todos) |> Js.Json.stringify
}
