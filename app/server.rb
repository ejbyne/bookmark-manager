env = ENV["RACK_ENV"] || "development"
require 'data_mapper'
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
require './lib/link'
require 'sinatra/base'
DataMapper.finalize
DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

  get '/' do
    @links = Link.all
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
