@bs.module external helmet: unit => Express.Middleware.t = "helmet"
@bs.module
external compression: unit => Express.Middleware.t = "compression"

open Express

let app = express()

App.use(app, helmet())
App.use(app, compression())
App.use(app, Cors.cors())
App.use(app, Middleware.json())
App.use(app, Controller.logRequest)

App.get(app, ~path="/", Controller.welcome)
App.get(app, ~path="/todos", Controller.Todos.getAll)
App.get(app, ~path="/todos/:id", Controller.Todos.get)
App.post(app, ~path="/todos", Controller.Todos.create)
App.put(app, ~path="/todos/:id", Controller.Todos.update)

App.useOnPath(app, ~path="*", Controller.badRessource)
