class BookmarkManager < Sinatra::Base

  register Sinatra::Partial
  include Helpers

  set :views, Proc.new { File.join(root, "..", "views") }
  set :public_folder, Proc.new { File.join(root, "..", "..", "public") }
  enable :sessions
  set :session_secret, 'super secret'
  set :partial_template_engine, :erb
  use Rack::Flash
  use Rack::MethodOverride

  run! if app_file == $0
end