# rescript-example-app

This is just an experiment to create an example CRUD app written in ReScript on front end and back end

## Example Calls

```sh
curl http://localhost:8080

curl http://localhost:8080/todos
curl http://localhost:8080/todos?completed=true
curl http://localhost:8080/todos?completed=false

curl -X POST -H "Content-Type: application/json" -d "{ \"message\": \"My new TODO\" }" http://localhost:8080/todos

# replace :id by a real id
curl -X PUT -H "Content-Type: application/json" -d "{ \"message\": \"The TODO is edited\", \"completed\": true }" http://localhost:8080/todos/:id
```
