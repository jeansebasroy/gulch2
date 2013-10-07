require 'spec_helper'

describe "Tariff Tools" do
  
	describe "input page" do

		it "should have a form for data entry" do
			visit '/'
			expect(page).to have_content('Zip code')
			expect(page).to have_content('Demand')
			expect(page).to have_content('Usage')
		end
	end

end
