module L = BsWinston.Logger
module T = BsWinston.Transport
module F = BsWinston.Format
module B = BsWinston.Builder

let levelString =
  "LEVEL" |> Js.Dict.get(Node.Process.process["env"]) |> Js.Option.getWithDefault("info")
let level = if levelString === "debug" {
  B.Debug
} else if levelString === "warn" {
  B.Warn
} else if levelString === "verbose" {
  B.Verbose
} else if levelString === "error" {
  B.Error
} else {
  Info
}

let logger =
  B.create()
  ->B.setLevel(level)
  ->B.addFormat(F.combine(list{F.createTimestamp(), F.createPrettyPrint(~colorize=true, ())}))
  ->B.addTransport(T.createConsole())
  ->B.build

let log: (L.t => L.t, string) => unit = (loggerLevel, message) =>
  logger->loggerLevel->L.withMessage(message)->L.log

let debug = log(L.debug)
let info = log(L.info)
let warn = log(L.warn)
let error = log(L.error)
