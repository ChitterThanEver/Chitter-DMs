require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/user_repository'
require_relative './lib/dm_repository'
require 'sinatra/flash'
require_relative './lib/database_connection'

DatabaseConnection.connect

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
    enable :sessions
    also_reload './lib/user_repository'
  end

  def check_handle_exists(handle)
    user_repo = UserRepository.new
    return user_repo.list_handles.include?(handle)
  end

  post '/login' do
    handle = params[:handle]
    if check_handle_exists(handle)
      session[:handle] = handle
      redirect '/'
    else
      flash[:invalid_handle] = "Handle Does Not Exist"
      redirect '/'
    end
  end

  get '/logout' do
    session[:handle] = nil
    redirect '/'
  end

  get '/' do
    @dm_repo = DMRepository.new
    if session[:handle]
      @inbox = @dm_repo.find_inbox(session[:handle])
    end
    return erb(:index)
  end
end
