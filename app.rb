require 'sinatra'
require 'sqlite3'

db = SQLite3::Database.new("db/students.db")
db.results_as_hash = true

get "/" do
  redirect "/students"
end

# Get a list of all students
get "/students" do
  @students = db.execute("select * from students")
  erb :"students/index"
end

# Add a student
get "/students/new" do
  erb :"students/new"
end

post "/students" do
  @student = db.execute("insert into students (name, campus, age) values (?, ?, ?)", params[:name], params[:campus], params[:age])
  redirect "/"
end

# Find a student
get "/students/find" do
  erb :"students/find"
end

post "/students/find" do
  @student_id = db.execute("select id from students where name = ? limit 1", params[:name])

  if @student_id != []
    # Do  weird tricks to get the string because we're getting results as a hash (see line 5)
    @student_id = @student_id.first["id"]
    redirect "/students/#{@student_id}"
  else
    # Stay on the same page but output an error
    @error = "Sorry, no student by the name of #{params[:name]} found."
    erb :"students/find"
  end
end

# Delete a student
delete "/students/:id" do
  @student = db.execute("delete from students where id = ?", params["id"])
  redirect "/"
end

# Edit a student
get "/students/:id/edit" do
  @student =  db.execute("select * from students where id = ?", params["id"])
  @student = @student.first
  erb :"students/edit"
end

put "/students/:id" do
  db.execute("update students set name = ?, campus = ?, age = ? where id = ?", params["name"], params["campus"], params["age"], params["id"])
  redirect "/students/#{params['id']}"
end

# Select a specific student and show details
get "/students/:id" do
  @student =  db.execute("select * from students where id = ?", params["id"])
  @student = @student.first
  erb :"students/show"
end





