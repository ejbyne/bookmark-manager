require 'bcrypt'
# require 'mailgun'
require 'rest-client'

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation
  
  validates_confirmation_of :password
  # validates_uniqueness_of :email

  MAILGUN_API = ENV['MAILGUN_API']
  BOOKMARK_URL = ENV['BOOKMARK_URL']

  property :id,                       Serial
  property :email,                    String,  :unique => true,  :message => "This email is already taken"
  property :password_digest,          Text
  property :password_token,           Text
  property :password_token_timestamp, Time

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end


  def send_message
    RestClient.post "https://#{MAILGUN_API}"\
    "@api.mailgun.net/v2/sandbox4478906f6e744d7e900a98a5c2509c4c.mailgun.org/messages",
    :from => "Mailgun Sandbox <postmaster@sandbox4478906f6e744d7e900a98a5c2509c4c.mailgun.org>",
    :to => "Edward Byne <ejbyne@gmail.com>",
    :subject => "Bookmark Manager - password reset email",
    :text => "Hello #{self.email}. Please follow this link within one hour to change your email: #{BOOKMARK_URL}/users/change_password/#{self.password_token}."
  end

end