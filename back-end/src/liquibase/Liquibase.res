open Js.Promise

let liquibase = ResLiquibase.liquibase({
  changeLogFile: "liquibase/liquibase-changelog.sql",
  driver: "org.postgresql.Driver",
  classpath: "../database/postgresql-42.2.16.jar",
  url: "jdbc:postgresql://localhost:5432/postgres",
  username: "postgres",
  password: "postgres",
})

ResLiquibase.run(liquibase, #update, ()) |> then_(() => {
  Js.log("Liquibase updare finished successfully")
  resolve()
}) |> catch(error => {
  Js.log2("Liquibase updare failed: error=", error)
  resolve()
})
