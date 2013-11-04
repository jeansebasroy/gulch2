require "spec_helper"

describe TariffMailer do
  describe "zip missing from database" do
    let(:site) { FactoryGirl.create(:site) }
    let(:mail) { TariffMailer.zip_db_missing(site) }

    it "sends email with missing zip to support@gulchsolutions.com" do
      mail.subject.should eq("Notice: Zip Code Missing from Database")
      mail.to.should eq(["support@gulchsolutions.com"])
      mail.body.should match(site.zip_code)
      #include contact info from submitted user
    end

  end

  describe "user doesn't have permission for that zip code" do

  end

#  describe "password_reset" do
#    let(:user) { FactoryGirl.create(:user, :password_reset_token => "anything") }
#    let(:mail) { UserMailer.password_reset(user) }

#    it "sends user password reset url" do
#      mail.subject.should eq("Password Reset")
#      mail.to.should eq([user.email])
#      mail.from.should eq(["support@gulchsolutions.com"])
#      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
#    end
#  end

#  describe "new user" do
#    let(:user) { FactoryGirl.create(:user) }
#    let(:mail) { UserMailer.new_user_info(user) }

#    it "info sent to info@gulchsolutions.com" do
#      mail.subject.should eq("New User Sign Up")
#      mail.to.should eq(["info@gulchsolutions.com"])
#      mail.body.should match(user.first_name)
#      mail.body.should match(user.last_name)
#      mail.body.should match(user.email)
#      mail.body.should match(user.phone)
#    end

#    it "gets a welcome email" do
#      mail.subject.should eq("Welcome to Gulch Solutions")
#      mail.to.should eq([user.email])
#    end
#  end


end
