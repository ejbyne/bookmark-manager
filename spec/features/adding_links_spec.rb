require 'spec_helper'

feature "User adds a new link" do

  before(:each) do
    User.create(  :id =>                    1,
                  :email =>                 "test@test.com",
                  :password =>              'test',
                  :password_confirmation => 'test')
  end

  scenario "when browsing the homepage" do
    expect(Link.count).to eq(0)
    log_in('test@test.com', 'test')
    add_link("http://www.makersacademy.com/", "Makers Academy", "Learn to code in 12 weeks")
    expect(Link.count).to eq(1)
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
    expect(link.description).to eq("Learn to code in 12 weeks")
  end

  scenario "with a few tags" do
    log_in('test@test.com', 'test')
    add_link( "http://www.makersacademy.com/",
              "Makers Academy",
              "Learn to code in 12 weeks",
              ['education', 'ruby'])
    link = Link.first
    expect(link.tags.map(&:text)).to include('education')
    expect(link.tags.map(&:text)).to include('ruby')
  end

  scenario "with the user id being added to the link" do
    log_in('test@test.com', 'test')
    add_link("http://www.makersacademy.com/", "Makers Academy", "Learn to code in 12 weeks")
    link = Link.first
    expect(link.user_id).not_to be(nil)
  end

  scenario "but a link may not be added if there is no user logged in" do
    visit('/')
    expect(page).not_to have_link('Add link')
    visit('/links/new')
    expect(page).not_to have_content('Submit a new link')
    expect(page).to have_content('Please log in to add a link')
  end

  def add_link(url, title, description, tags = [])
    click_link 'Add link'
    within('#container') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      fill_in 'description', :with => description
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
