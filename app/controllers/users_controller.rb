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
      @user.save
      session[:user_id] = @user.id
      redirect "/records"
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
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/records'
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if is_logged_in? 
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end