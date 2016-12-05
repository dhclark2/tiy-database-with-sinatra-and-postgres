require "sinatra"
require "sinatra/reloader" if development?
require "pg"

# Go to localhost:4567 in webbrowser to run

get "/" do
  erb :home
end

get "/employees" do
  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("SELECT * FROM employees")

  erb :employees
end

get "/show_employee" do
  id = params["id"]
  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("SELECT * FROM employees WHERE id = $1",[id])

  erb :show_employee
end

get "/edit_employee" do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("SELECT * FROM employees WHERE id = $1",[id])

  @rows = @rows.first
  erb :edit_employee

end

get "/delete_employee" do
  id = params["id"]

  database = PG.connect(dbname: "tiy-database")
  database.exec("DELETE FROM employees WHERE id = $1",[id])

  redirect to("/employees")
end

get "/search" do
  search = params["search"]
  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("SELECT * FROM employees WHERE name LIKE $1 OR github = $2 OR slack = $3",["%#{search}%", search, search])

  erb :employees
end

get "/new_employee" do
  erb :new_employee
end

post "/create_employee" do
  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  position = params["position"]
  github = params["github"]
  slack = params["slack"]

  database = PG.connect(dbname: "tiy-database")
  database.exec("INSERT INTO employees(name, address, phone, salary, position, github, slack) VALUES($1, $2, $3, $4, $5, $6, $7)",[name, address, phone, salary, position, github, slack])

  redirect to("/employees")
end

post "/update_employee" do
  id = params["id"]
  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  position = params["position"]
  github = params["github"]
  slack = params["slack"]

  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("UPDATE employees SET name = $1, address = $2, phone = $3, salary = $4, position = $5, github = $6, slack = $7 WHERE id = $8",[name, address, phone, salary, position, github, slack, id])

  redirect to("/employees")
end
