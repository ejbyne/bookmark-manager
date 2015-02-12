require 'spec_helper'

feature "User adds a new link" do

  before(:each) do
    User.create(  :email =>                 "test@test.com",
                  :password =>              'test',
                  :password_confirmation => 'test')
  end

  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    log_in('test@test.com', 'test')
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  scenario "with a few tags" do
    log_in('test@test.com', 'test')
    add_link( "http://www.makersacademy.com/",
              "Makers Academy",
              ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include('education')
    expect(link.tags.map(&:text)).to include('ruby')
  end

  scenario "with the user id being added to the link" do
    log_in('test@test.com', 'test')
    add_link("http://www.makersacademy.com/", "Makers Academy")
    link = Link.new
    expect(link.user_id).not_to be(nil)
  end

  def add_link(url, title, tags = [])
    click_link 'Add link'
    within('#container') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end
  end

  def log_in(email, password)
    visit('/')
    click_link 'Sign in'
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button 'Sign in'
  end

end
