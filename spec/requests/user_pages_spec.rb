require 'spec_helper'

describe "User Pages" do
  describe "login page" do
    it "should have the content for 'Login'" do
    	visit '/login'
    	expect(page).to have_content('Login')
    	expect(page).to have_content('Email')
    	expect(page).to have_content('Password')

    	# expect to have 'Login' button
    	# expect to have link to 'Sign Up for Demo'
     
    end
  end

  describe "sign up page" do
    before { visit signup_path }

    it "should have the content for 'Sign Up'" do
      expect(page).to have_content('First name')
      expect(page).to have_content('Last name')
      expect(page).to have_content('Email')
    # expect(page).to have_content('Phone')
    # expect(page).to have_content('Company')
    # expect(page).to have_content('Address')
    # expect(page).to have_content('City')
    # expect(page).to have_content('State')
    # expect(page).to have_content('Zip')
      expect(page).to have_content('Password')
      expect(page).to have_content('Confirmation')
      
      # expect to have 'Create my account' button
      # expect to have some indication that this is for a 'demo' account
    end



    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First Name",   with: "Example"
        fill_in "Last Name",    with: "User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "123456"
        fill_in "Confirmation", with: "123456"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        #it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome to Gulch Solutions') }
    end
  end

end
