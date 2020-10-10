open Js.Promise

module Todos = {
  let getAll = () => make((~resolve, ~reject) => resolve(. Js.Json.null))

  let getByCompletness = cfilter => make((~resolve, ~reject) => resolve(. Js.Json.null))

  let getById = id => make((~resolve, ~reject) => resolve(. Js.Json.null))

  let update = (id, description, completed) => make((~resolve, ~reject) => ())

  let create = description => make((~resolve, ~reject) => ())
}
