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
  erb :edit_employee

end

# get "/delete_employee" do
#   name = params["name"]
#   database = PG.connect(dbname: "tiy-database")
#   @rows = database.exec("DELETE * FROM employees WHERE name = $1",[name])
#
#   redirect to("/employees")
# end

get "/search" do
  id params["id"]
  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("SELECT * FROM employees WHERE id = $1",[id])

  erb :sumbit
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
  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  position = params["position"]
  github = params["github"]
  slack = params["slack"]

  database = PG.connect(dbname: "tiy-database")
  @rows = database.exec("UPDATE employees where id =$1,(name, address, phone, salary, position, github, slack) SET VALUES($1, $2, $3, $4, $5, $6, $7)",[name, address, phone, salary, position, github, slack])

  redirect to("/employees")
end
