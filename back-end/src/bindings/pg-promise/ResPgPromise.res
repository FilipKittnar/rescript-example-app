type database
type connectionConfiguration = {
  host: string,
  port: int,
  database: string,
  user: string,
  password: string,
}
type t = (. connectionConfiguration) => database

@bs.module external pgPromise: unit => t = "pg-promise"
@bs.send external any: (database, string) => Js.Promise.t<array<Js.Json.t>> = "any"
@bs.send external none: (database, string, Js.Dict.t<Js.Json.t>) => Js.Promise.t<unit> = "none"
