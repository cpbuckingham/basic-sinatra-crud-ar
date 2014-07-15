require_relative "./../app"
require "capybara/rspec"
ENV["RACK_ENV"] = "test"
require "rack-flash"
require "gschool_database_connection"

Capybara.app = App


RSpec.configure do |config|
  config.before do
    database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("BEGIN")
  end

  config.after do
    database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

    database_connection.sql("ROLLBACK")
  end
end
