class BookmarkManager

  post '/links' do
    url = params["url"]
    title = params["title"]
    description = params["description"]
    tags = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag, :user_id => current_user.id)
    end
    time = Time.now
    Link.create(:url => url, :title => title, :description => description, :tags => tags, :created_at => time, :created_at_string => 
    time.strftime("%d-%m-%Y %H:%M"), :user_id => current_user.id)
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
