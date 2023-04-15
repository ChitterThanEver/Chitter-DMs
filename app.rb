require "sinatra/base"
require "sinatra/reloader"
require_relative "./lib/user_repository"
require_relative "./lib/dm_repository"
require "sinatra/flash"
require_relative "./lib/database_connection"

DatabaseConnection.connect

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    register Sinatra::Flash
    enable :sessions
    also_reload "./lib/user_repository"
    also_reload "./lib/dm_repository"
  end

  post "/login" do
    handle = params[:handle]
    if check_handle_exists(handle)
      session[:handle] = handle
      redirect "/"
    else
      flash[:invalid_handle] = "Handle Does Not Exist"
      redirect "/"
    end
  end

  get "/logout" do
    session[:handle] = nil
    redirect "/"
  end

  get "/" do
    @dm_repo = DMRepository.new
    @inbox = @dm_repo.find_inbox(session[:handle]) if session[:handle]
    return erb(:index)
  end

  get "/send_message" do
    return erb(:send_message)
  end

  post "/send_message" do
    if !check_handle_exists(params[:recipient_handle])
      flash[:invalid_handle] = "Handle Does Not Exist"
      redirect "/send_message"
    elsif blocked?(session[:handle], params[:recipient_handle])
      flash[:blocked] = "You are blocked by this user, message can't be sent"
      redirect "/send_message"
    else
      new_dm = DM.new
      new_dm.recipient_handle = params[:recipient_handle]
      new_dm.contents = params[:contents]
      new_dm.sender_handle = session[:handle]

      @dm_repo = DMRepository.new
      @dm_repo.add(new_dm)
      flash[:message_sent] = "Message sent"
      redirect "/send_message"
    end
  end

  helpers do
    def check_handle_exists(handle)
      user_repo = UserRepository.new
      return user_repo.list_handles.include?(handle)
    end

    def blocked?(sender_handle, recipient_handle)
      user_repo = UserRepository.new
      recipient_id = user_repo.find_id(recipient_handle)
      blocked_users = user_repo.find_blocked(recipient_id)

      blocked = false
      blocked_users.each do |user|
        user.handle == sender_handle ? blocked = true : next
      end

      return blocked
    end
  end
end
