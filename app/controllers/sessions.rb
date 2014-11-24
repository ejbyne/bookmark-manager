class BookmarkManager

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    if session[:user_id]
      flash[:errors] = ["You are already signed in"]
      redirect to('/')
    end
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      redirect to('/sessions/new')
    end
  end

  delete '/sessions' do
    flash[:notice] = "Good bye!"
    session[:user_id] = nil
    redirect to('/')
  end

end