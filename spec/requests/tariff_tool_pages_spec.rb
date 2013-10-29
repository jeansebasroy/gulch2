require 'spec_helper'
require 'factory_girl_rails'

describe "Tariff Tool pages" do
  
	subject { page } 

    let(:sign_in) { "Sign in" }  
    let(:submit) { "Submit" }

	let(:user) { FactoryGirl.create(:user) }
    before { visit signin_path }
    	
    before do
       	fill_in "Email",        with: user.email
       	fill_in "Password",     with: user.password
       	click_button "Sign in"
    end

    #before { click_button sign_in }
	# before { visit '/input' }
	# need to use correct 'path'
	
	describe "Input page" do
    
		it { should have_title('Input') }
		it { should have_content('Zip code') }
		it { should have_content('Demand in kw') }
		it { should have_content('Usage in kwh') }
		it { should have_content('Bill date') }
		it { should have_content('Phases') }

		it { should_not have_content('View Demo') }
		it { should_not have_content('Contact') }
		it { should_not have_content('Sign In') }

		#it { should have_content('Profile') }
		it { should have_content('Bill Comparison') }
		it { should have_link('Bill Comparison', 	href: '/input') }
		it { should have_link('Sign Out',			href: signout_path) }
		
		describe "after invalid Input submission" do
			
			before do
				fill_in "Zip code",			with: 9
				click_button "Submit"
			end

			it { should have_title('Input') }
			it { should_not have_title('Bill Comparison') }

		end

		describe "after valid Input submission" do

			before do
       			fill_in "Zip code",      with: 07004
       			fill_in "Demand",		 with: 100
       			fill_in "Usage",  		 with: 10000
       			fill_in "Bill date",     with: 10/1/2013
       			fill_in "Phases",        with: "3-phase"
       			click_button "Submit"      			
    		end

			describe  "Tariff Tool page" do

				it { should have_title('Bill Comparison') }
				it { should have_content('Billing Period:') }
				it { should have_content('kWh used = ') }
				it { should have_content('Billed Load in kW =') }
				it { should have_content('Rate:') }
				it { should have_content('Total Bill =') }

			end	
		end
	end
end
