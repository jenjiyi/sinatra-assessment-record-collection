require './config/environment'

class ApplicationController < Sinatra::Base
   

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "records_session_secret"
  end

  get '/' do 
    erb :index
  end

  helpers do
    def is_logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def login (username, password)
    @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(password)
        session[:user_id] = @user.id
        redirect to '/records'
      else
        erb :'/users/login', locals: {message: "No match found. Please try again."}
      end
    end

    def logout
      if is_logged_in? 
        session.clear
        redirect to '/login'
      else
        redirect to '/'
      end
    end

  end

end