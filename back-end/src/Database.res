let pgp = ResPgPromise.pgPromise()
let database = pgp(.{
  host: "localhost",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "postgres",
})
