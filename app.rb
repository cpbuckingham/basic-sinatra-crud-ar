require "sinatra"
require "rack-flash"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    erb :register
  end

  post "/" do
    username = params[:username]
    password = params[:password]
    if username == "" && password == ""
      flash[:notice] = "No username or password entered"
      redirect '/'
    elsif password == ""
      flash[:notice] = "No password entered"
      redirect '/'
    elsif username == ""
      flash[:notice] = "No username entered"
      redirect '/'
    elsif @database_connection.sql("SELECT username, password from users where username = '#{username}' and password = '#{password}'") == []
      flash[:notice] = "Incorrect Username and Password"
      redirect '/'
    else
      user_id_hash = session[:user] = @database_connection.sql("Select id from users where username = '#{username}'").reduce
      user_id = user_id_hash["id"]
      session[:user] = user_id
      @list_users = @database_connection.sql("Select username from users")
      @users_fish = @database_connection.sql("SELECT name, wiki from fish where user_id = #{session[:user]}")
      erb :loggedin, :locals => {:username => username}
    end
  end

  get "/registration" do
    erb :registration
  end

  post "/registration" do
    username = params[:username]
    password = params[:password]
    if username == "" && password == ""
      flash[:notice] = "No username or password entered"
    elsif password == ""
      flash[:notice] = "No password entered"
    elsif username == ""
      flash[:notice] = "No username entered"
    else
      if @database_connection.sql("SELECT username from users where username = '#{username}'") == []
        @database_connection.sql("INSERT INTO users (username, password) values ('#{username}', '#{password}')")
        flash[:notice] = "Thank you for registering"
        redirect '/'
      else
        flash[:notice] = "Username already taken"
        redirect back
      end
    end
    redirect back
  end

  get "/loggedin" do
    user_id =session[:user]
    @users_fish = @database_connection.sql("SELECT * from fish where user_id = #{session[:user]}")
    @list_users = @database_connection.sql("Select username from users")
    @fish_id = @database_connection.sql("select fish_id from favorite")
    erb :loggedin, :locals => {:username => user_id}
  end

  post "/loggedin" do
    name = params[:name]
    @database_connection.sql("delete from fish where name= '#{name}'")
    flash[:notice] = "BAM! fish is gone."
    redirect "/loggedin"
  end

   get "/users_alphabet" do
    user_id = session[:user]
    erb :users_alphabet, :locals => {:username => user_id}
  end

  post "/users_alphabet" do
    username = params[:name]
    @database_connection.sql("delete from users where username = '#{username}'")
    flash[:notice] = "BAM! they are gone."
    redirect "/loggedin"
  end

  get "/users_descending" do
    users_id = session[:user]
    erb :users_descending, :locals => {:username => users_id}
  end

  post "/add_fish" do
    fish_name = params[:fish_name]
    fish_wiki = params[:fish_wiki]
    @database_connection.sql("INSERT INTO fish (name, wiki, user_id) values ('#{fish_name}', '#{fish_wiki}', #{session[:user]})")
    redirect "/loggedin"
  end

  post "/favorite_fish" do
    user_id = session[:user]
    fish_id = params[:fish_id].to_i
    @favorite_fish = @database_connection.sql("insert into favorite (fish_id, user_id) values ('#{fish_id}', '#{user_id}')")
    redirect "/loggedin"
    flash[:notice] = "yeah! you like that fish"
  end

  post "/unfavorite_fish" do
    user_id = session[:user]
    @unfavorite_fish = @database_connection.sql("delete from favorite where fish_id ='#{user_id}'")
    redirect "/loggedin"
    flash[:notice] = "bummer! you don't like that fish"
  end
end



