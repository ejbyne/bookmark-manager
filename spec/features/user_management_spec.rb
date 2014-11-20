require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs up" do

  scenario "when being logged out" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, ed@example.com")
    expect(User.first.email).to eq("ed@example.com")
  end

  # def sign_up(  email = "ed@example.com",
  #               password = "oranges!")
  #   visit '/users/new'
  #   expect(page.status_code).to eq(200)
  #   fill_in :email, :with => email
  #   fill_in :password, :with => password
  #   click_button "Sign up"
  # end

  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User signs in" do

  before(:each) do
    User.create(  :email =>                 "test@test.com",
                  :password =>              'test',
                  :password_confirmation => 'test')
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User signs out' do

  before(:each) do
    User.create(  :email => "test@test.com",
                  :password => 'test',
                  :password_confirmation => 'test')
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User has forgotten password' do

  before(:each) do
    User.create(  :email => "test@test.com",
                  :password => 'test',
                  :password_confirmation => 'test')
    allow_any_instance_of(User).to receive(:send_message).and_return(nil)
  end

  scenario 'and wants to reset the password' do
    user = User.first(:email => "test@test.com")
    visit '/sessions/new'
    click_button "Forgot Password?"
    expect(page).to have_content("Please enter your email")
    fill_in 'email', :with => 'test@test.com'
    click_button "Request password reset"
    expect(page).to have_content("Please check your email inbox for further information")
    user = User.first(:email => "test@test.com")
    expect(user.password_token.nil?).to be false
    expect(user.password_token_timestamp.nil?).to be false
  end

  scenario 'and resets their password within an hour' do
    user = User.first(:email => "test@test.com")
    old_digest = user.password_digest
    visit '/sessions/new'
    click_button "Forgot Password?"
    fill_in 'email', :with => 'test@test.com'
    click_button "Request password reset"
    user = User.first(:email => "test@test.com")
    visit "/users/change_password/#{user.password_token}"
    expect(page).to have_content("Please enter new password")
    fill_in 'password', :with => 'test2'
    fill_in 'password_confirmation', :with => 'test2'
    click_button 'Change Password'
    user = User.first(:email => "test@test.com")
    expect(old_digest).not_to eq(user.password_digest)
    expect(user.password_token).to be nil
    expect(page).to have_content("Your password has been changed")
  end

  scenario 'and tries to reset their password after an hour' do
    user = User.first(:email => "test@test.com")
    old_digest = user.password_digest
    visit '/sessions/new'
    click_button "Forgot Password?"
    fill_in 'email', :with => 'test@test.com'
    click_button "Request password reset"
    Timecop.travel(Time.now + 3601)
    user = User.first(:email => "test@test.com")
    visit "/users/change_password/#{user.password_token}"
    expect(page).to have_content("Password reset request timed out. Please request new forgotten password email")
    expect(page).to have_content("Please enter your email")
  end

end

