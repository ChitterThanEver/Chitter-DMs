require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/user_repository'
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
    if user_repo.list_handles.include?(handle)
      return true
    end
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
    @user_repo = UserRepository.new
    return erb(:index)
  end

  get '/blocked_list' do
    repo = UserRepository.new
    user = repo.get_user_by_handle(session[:handle])
    @all = repo.all
    @blocked = repo.find_blocked(user.id)
    return erb(:blocked_list)
  end
  
  # def create_block_list_hash(users, blocked)
  #   hash = Hash.new
  #   users.each do |user|
  #     hash[user.handle] = blocked.include? user.handle
  #   end

  #   return hash
  # end
end