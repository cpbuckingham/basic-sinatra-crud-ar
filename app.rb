require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
    erb :register
  end
  post "/" do
    username = params[:username]
    password = params[:password]
    if @database_connection.sql("SELECT username, password from users where username = '#{username}' and password = '#{password}'") == []
      flash[:notice] = "Incorrect Username and Password"
    else
      # user_id_hash = session[:user] = @database_connection.sql("Select id from users where username = '#{username}'").reduce
      # user_id = user_id_hash["id"]
      session[:user] = username
      @list_users = @database_connection.sql("Select username from users")
      erb :loggedin, :locals => {:username => username}
    end
  end
  get "/loggedin" do
    username =session[:user]
    @list_users = @database_connection.sql("Select username from users")
    erb :loggedin, :locals => {:username => username}
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

  get"/users_alphabet" do
    username = session[:user]
    erb :users_alphabet, :locals => {:username => username}
  end

  post "/users_alphabet" do
    username = params[:name]
    @database_connection.sql("delete from users where username = '#{username}'")
    flash[:notice] = "BAM! they are gone."
    redirect "/loggedin"
  end

  post "/add_fish" do
    fish_name = params[:fish_name]
    fish_wiki = params[:fish_wiki]
    @database_connection.sql("INSERT INTO fish (name, wiki, user_id) values ('#{fish_name}', '#{fish_wiki}', #{session[:user]})")
  end

end

