require 'spec_helper'

describe "Tariff Tool pages" do
  
	describe "entry page" do

		it "should have a form for 'Entry'" do
			visit '/entry'
			expect(page).to have_content('Zip code')
			expect(page).to have_content('Demand in kw')
			expect(page).to have_content('Usage in kwh')
			expect(page).to have_content('Bill date')
			expect(page).to have_content('Phases')

		end
	end


	describe "tariff page" do

		# need to submit data to have this show

		it "should have an output of the 'Tariff'" do
			#visit '/tariff'
			#expect(page).to have_content('Bill Comparison')
			#expect(page).to have_content('Billing Period:')
			#expect(page).to have_content('kWh used =')
			#expect(page).to have_content('Billed Load in kW =')
			#expect(page).to have_content('Rate:')
			#expect(page).to have_content('Total Bill =')
	
		end
	
	end

end
