type liquibaseConfig = {
    changeLogFile: string,
    driver: string,
    classpath: string,
    url: string,
    username: string,
    password: string
}

type t;

@bs.module external liquibase: liquibaseConfig => t = "liquibase"
@bs.send external run: (t, [
    | #update
    | #updateSQL
    | #status
    | #diff
    | #snapshot
    | #generateChangeLog
  ], ~params:@bs.string [
    | @bs.as("--verbose") #verbose
  ]=?, ()) => Js.Promise.t<unit> = "run"