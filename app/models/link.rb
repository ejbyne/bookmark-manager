class Link

  include DataMapper::Resource

  property :id,     						Serial
  property :title,  						String
  property :url,    						String
  property :created_at,					Time
  property :created_at_string,	String

  has n, 			:tags,     :through => Resource
  belongs_to 	:user

end
