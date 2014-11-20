class BookmarkManager

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do
    @user = User.create( :email => params[:email],
                        :password => params[:password],
                        :password_confirmation => params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/users/forgot_password' do
    erb :"users/forgot_password"
  end

  post '/users/forgot_password' do
    user = User.first(:email => params[:email])
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    @links = Link.all
    flash.now[:notice] = "Please check your email inbox for further information"
    erb :index
  end

  get '/users/change_password/:token' do
    @token = params[:token]
    user = User.first(:password_token => @token)
    if Time.now < (user.password_token_timestamp + 3600)
      erb :"users/change_password"
    else
      flash[:notice] = "Password reset request timed out. Please request new forgotten password email"
      redirect to 'users/forgot_password'
    end
  end

  post '/users/change_password' do
    user = User.first(:password_token => params[:token])
    user.update(  :password => params[:password],
                  :password_confirmation => params[:password_confirmation],
                  :password_token => nil,
                  :password_token_timestamp => nil)
    @links = Link.all
    flash.now[:notice] = "Your password has been changed"
    erb :index
  end

end