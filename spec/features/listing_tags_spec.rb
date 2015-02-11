require 'spec_helper'

feature "User browses the list of tags" do

  before(:each) {
      Link.create(  :url => "http://www.makersacademy.com",
                    :title => "Makers Academy",
                    :tags => [Tag.first_or_create(:text => 'education')])
      Link.create(  :url => "http://www.google.com",
                    :title => "Google",
                    :tags => [Tag.first_or_create(:text => 'search')])
      Link.create(  :url => "http://www.bing.com",
                    :title => "Bing",
                    :tags => [Tag.first_or_create(:text => 'search')])
      Link.create(  :url => "http://www.code.org",
                    :title => "Code.org",
                    :tags => [Tag.first_or_create(:text => 'education')])
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content('education')
    expect(page).to have_content('search')
  end

end
