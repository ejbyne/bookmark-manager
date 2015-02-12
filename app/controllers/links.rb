class BookmarkManager

  post '/links' do
    url = params["url"]
    title = params["title"]
    tags = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag, :user_id => current_user.id)
    end
    Link.create(:url => url, :title => title, :tags => tags, :user_id => current_user.id)
    redirect to('/')
  end

  get '/links/new' do
    if current_user
      erb :"links/new"
    else
      @links = Link.all
      @tags = Tag.all
      flash[:notice] = "Please log in to add a link"
      erb :index
    end
  end

end
