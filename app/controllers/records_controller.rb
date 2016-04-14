class RecordsController < ApplicationController

  get '/records' do
    if !is_logged_in?
      redirect "/login"
    else
      @records = Record.all
      erb :'/records/records'
    end
  end

  get '/records/new' do 
    erb :'/records/create'
  end


  post '/records' do 
    if (params[:album_name]).empty? 
      erb :'/records/create', locals: {message: "Oops, you didn't fill out album field."}
    else
      user = User.find_by_id(session[:user_id])
      @record = Record.new(params)
      # @record = Record.create(artist_name: params["artist_name"], album_name: params[:album_name], rating: params[:rating], release_year: params[:release_year], comments: params[:comments], user_id: user.id)
      @record.user_id = user.id
      @record.save
      redirect "/records/#{@record.id}"
    end
  end


  get '/records/:id' do
    @record = Record.find_by_id(params[:id])
    erb :'/records/show'
  end


  get '/records/:id/edit' do
     @record = Record.find_by_id(params[:id])
     erb :'/records/edit'
  end

  patch '/records/:id' do 
    if (params[:album_name]).empty? 
      @record = Record.find_by_id(params[:id])
      erb :'/records/edit', locals: {message: "You didn't include an album. Fill out and save again."}
    else
      @record = Record.find_by_id(params[:id])
      @record.update(artist_name: params["artist_name"], album_name: params[:album_name], rating: params[:rating], release_year: params[:release_year], comments: params[:comments])
      @record.save
      redirect "/records/#{@record.id}"
    end
  end

  delete '/records/:id/delete' do
    @record = Record.find_by_id(params[:id])
    if is_logged_in?
      @record = Record.find_by_id(params[:id])
      if @record.user_id == current_user.id
        @record.delete
        redirect '/records'
      else
        redirect '/records'
      end
    else
      redirect '/login'
    end
  end
end