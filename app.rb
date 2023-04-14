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

  get '/blocked_list' do
    repo = UserRepository.new
    user = repo.get_user_by_handle(session[:handle])
    @all = repo.all
    @blocked = repo.find_blocked(user.id)
    return erb(:blocked_list)
  end
  
  post '/blocked_list' do
    repo = UserRepository.new

    user_id = handle_to_id(session[:handle])

    old_list = repo.find_blocked(user_id)
    new_list = params[:blocked]
    
    to_block_ids = (new_list - old_list).map { |handle| handle_to_id(handle)}
    to_unblock_ids = (old_list - new_list).map{ |handle| handle_to_id(handle)}

    block(user_id, to_block_ids)
    unblock(user_id, to_unblock_ids)

    redirect '/'
  end

  helpers do
    def check_handle_exists(handle)
      user_repo = UserRepository.new
      return user_repo.list_handles.include?(handle)
    end

    def handle_to_id(handle)
      UserRepository.new.get_user_by_handle(handle).id
    end

    def block(user_id, to_block_list)
      to_block_list.map do |id|
        UserRepository.new.add_to_blocked_list(user_id, id)
      end
    end

    def unblock(user_id, to_unblock_list)
      to_unblock_list.map do |id|
        UserRepository.new.remove_from_blocked_list(user_id, id)
      end
    end

  end
end
