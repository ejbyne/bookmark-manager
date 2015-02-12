require 'spec_helper'

feature "User browses the list of links" do

  before(:each) {
    User.create(  :id =>                    1,
                  :email =>                 "test@test.com",
                  :password =>              'test',
                  :password_confirmation => 'test')
    Link.create(  :url => "http://www.makersacademy.com",
                  :title => "Makers Academy",
                  :tags => [Tag.first_or_create(:text => 'education', :user_id => 1)],
                  :user_id => 1)
    Link.create(  :url => "http://www.google.com",
                  :title => "Google",
                  :tags => [Tag.first_or_create(:text => 'search', :user_id => 1)],
                  :user_id => 1)
    Link.create(  :url => "http://www.bing.com",
                  :title => "Bing",
                  :tags => [Tag.first_or_create(:text => 'search', :user_id => 1)],
                  :user_id => 1)
    Link.create(  :url => "http://www.code.org",
                  :title => "Code.org",
                  :tags => [Tag.first_or_create(:text => 'education', :user_id => 1)],
                  :user_id => 1)
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end

  scenario "filtered by a tag" do
    visit '/tags/search'
    expect(page).not_to have_content("Code.org")
    expect(page).to have_content("Google")
    expect(page).to have_content("Bing")
  end

end
