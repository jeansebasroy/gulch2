require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		#it { should have_title('Sign in') }
	end

	describe "sign in" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_content('Sign in') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }


			describe "after visiting another page" do
				before { visit signup_path }
				it { should_not have_selector('div.alert.alert-error') }
			end		
		end
	end
end
