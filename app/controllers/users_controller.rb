class UsersController < ApplicationController

  get '/records/users/:id' do
    @user = User.find_by_id(params[:id])
    @user.username = @user.slug
    redirect "/users/#{@user.username}"
  end 

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
  
  get '/signup' do
    if !is_logged_in?
      erb :'/users/create_user', locals: {message: "Please fill out the sign-up form to sign in"}
    else
     redirect to '/records'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.username != "" && @user.email != "" && @user.password != "" && @user.password != nil
      @user.username = @user.username.downcase
      if User.find_by(:username => @user.username)
        erb  :'/users/create_user', locals: {message: "An error occured while signing up. A user with this username already exists in the database."}
      else
        @user.save
        session[:user_id] = @user.id
        redirect "/records"
      end
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if !is_logged_in?
      erb :'users/login'
    else
      redirect "/records"
    end
  end

  post '/login' do
    login(params[:email], params[:password])
  end

  get '/logout' do
    logout
  end

end