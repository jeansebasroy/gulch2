require 'spec_helper'
require 'factory_girl_rails'

describe "Password Reset" do 
	
  let(:user) { FactoryGirl.create(:user) }

	it "emails user when requesting password reset" do
	
    visit signin_path
    click_link "Reset Password"
    fill_in "Email", with: user.email
    click_button "Reset Password"

    page.should have_content('Email sent with password reset instructions.')
    
	  last_email.to.should include(user.email)

	end
	
	it "does not email user when requesting password reset with invalid email" do
	
    visit signin_path
    click_link "Reset Password"
    fill_in "Email", with: "nobody@example.com"
    click_button "Reset Password"

    page.should have_content('Email sent with password reset instructions.')
    
	  last_email.should be_nil

	end

  	it "updates the user password when confirmation matches" do
      user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"

      click_button "Update Password"

      page.should have_content("Password confirmation doesn't match Password")

      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"

      click_button "Update Password"

      page.should have_content("Password has been reset.")

  	end

  	it "reports when password token has expired" do
      user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 5.hour.ago)
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"

      click_button "Update Password"

      page.should have_content("Password reset has expired.")

  	end

end