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

let debug = any => logger->L.debug->L.withMessage(any)->L.log
let info = any => logger->L.info->L.withMessage(any)->L.log
let warn = any => logger->L.warn->L.withMessage(any)->L.log
let error = any => logger->L.logErrorMsg(any)
