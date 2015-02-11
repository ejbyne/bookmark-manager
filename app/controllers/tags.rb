class BookmarkManager

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    @tags = Tag.all
    erb :index
  end

end