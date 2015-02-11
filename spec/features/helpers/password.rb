module PasswordHelpers

  def request_password_reset
    visit '/sessions/new'
    click_button "Forgot Password?"
    fill_in 'email', :with => 'test@test.com'
    click_button "Request password reset"
  end

end
