open Js.Promise

let liquibase = ResLiquibase.liquibase({
  changeLogFile: "src/liquibase/liquibase-changelog.sql",
  driver: "org.postgresql.Driver",
  classpath: "../database/postgresql-42.2.16.jar",
  url: "jdbc:postgresql://localhost:5432/postgres",
  username: "postgres",
  password: "postgres",
})

let update = () => ResLiquibase.run(liquibase, #update, ()) |> then_(() => {
    "Liquibase updare finished successfully"->Logger.info
    resolve()
  }) |> catch(_ => {
    "Liquibase updare failed"->Logger.error
    resolve()
  }) |> ignore
