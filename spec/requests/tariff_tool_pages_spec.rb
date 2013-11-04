require 'spec_helper'
require 'factory_girl_rails'

describe "Tariff Tool pages" do
  
	subject { page } 

    #let(:sign_in) { "Sign in" }  
    #let(:submit) { "Submit" }

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

		#let(:utility) 		{ FactoryGirl.create(:tariff_utility) }
		#let(:territory) 	{ FactoryGirl.create(:tariff_territory) }
		#let(:zip_code) 		{ FactoryGirl.create(:tariff_zip_code) }
		#let(:territory_zip)	{ FactoryGirl.create(:tariff_territory_zip_code_rel) }

		before do
			@test_utility = TariffUtility.create(utility_name: "JCP&L", 
				state: "NJ")
			@test_territory = TariffTerritory.create(territory_name: "JCP&L",
					tariff_utility_id: @test_utility.id)
			@test_zip_code = TariffZipCode.create(zip_code: "00000")
			@test_territory_zip = TariffTerritoryZipCodeRel.create(tariff_territory_id: @test_territory.id,
					tariff_zip_code_id: @test_zip_code.id)
			@test_season1 = TariffSeason.create(season_type: "All", season_start_date: "2010-01-01", 
					season_end_date: "2059-12-31", tariff_territory_id: @test_territory.id)
			@test_season2 = TariffSeason.create(season_type: "Winter", season_start_date: "2013-09-27", 
					season_end_date: "2014-01-27", tariff_territory_id: @test_territory.id)
			#@test_tou = TariffTou.create(tou_type: "Peak", day_of_weeK: "Week", start_time: "08:00:00",
			#		end_time: "20:00:00", tariff_seasons_id: @test_season.id)
			@test_meter_read1 = TariffMeterRead.create(meter_read_date: "2013-09-27", billing_month: "October", 
					billing_year: "2013" , tariff_territory_id: @test_territory.id)
			@test_meter_read2 = TariffMeterRead.create(meter_read_date: "2013-10-29", billing_month: "November", 
					billing_year: "2013" , tariff_territory_id: @test_territory.id)
			@test_billing_class = TariffBillingClass.create(billing_class_name: "GS Secondary Medium Three Phase",
					customer_type: "Commercial", phases: "3-phase", voltage: "Secondary",
					units: "kW", start_value: "10", end_value: "500", tariff_territory_id: @test_territory.id)
			@test_tariff1 = TariffTariff.create(tariff_name: "JCP&L Commercial Service (Energy)", 
					tariff_type: "Energy", tariff_billing_class_id: @test_billing_class.id)
			@test_tariff2 = TariffTariff.create(tariff_name: "JCP&L Commercial Service (Delivery)", 
					tariff_type: "Delivery", tariff_billing_class_id: @test_billing_class.id)
			@test_bill_group1 = TariffBillGroup.create(bill_group_name: "Billing Information For Supplier",
					bill_group_order: "2", tariff_billing_class_id: @test_billing_class.id)
			@test_bill_group2 = TariffBillGroup.create(bill_group_name: "Charges from JCP&L", 
					bill_group_order: "1", tariff_billing_class_id: @test_billing_class.id)
			@test_line_item1 = TariffLineItems.create(line_item_name: "BGS-FP (Winter)", line_item_type: "$/kWh", 
					effective_date: "2013-05-29", expiration_date: "", line_item_rate: "0.095672", tou_type: "All",
					bill_group_order: "1", tariff_tariff_id: @test_tariff1.id, tariff_season_id: @test_season1.id, 
					tariff_bill_group_id: @test_bill_group1.id)
			@test_line_item2 = TariffLineItems.create(line_item_name: "Customer Charge", line_item_type: "$/month", 
					effective_date: "2006-07-15", expiration_date: "", line_item_rate: "11.65", tou_type: "All",
					bill_group_order: "1", tariff_tariff_id: @test_tariff2.id, tariff_season_id: @test_season1.id, 
					tariff_bill_group_id: @test_bill_group2.id)
		end

		it { should have_title('Input') }
		it { should have_content('Zip code') }
		it { should have_content('Phases') }
		it { should have_content('Demand (in kW)') }
		it { should have_content('Usage (in kWh)') }
		it { should have_content('Bill Date (yyyy-mm-dd)') }
		
		it { should_not have_content('View Demo') }
		it { should_not have_content('Contact') }
		it { should_not have_content('Sign In') }

		#it { should have_content('Profile') }
		it { should have_content('Bill Comparison') }
		it { should have_link('Bill Comparison', 	href: '/input') }
		it { should have_link('Sign Out',			href: signout_path) }
		
		describe "after invalid Input submission" do
			
			describe "with zip code not in the database" do

				before do
					fill_in "Zip code",					with: "00001"
	       			select  "3-phase", 					from: "Phases"
    	   			fill_in "Demand (in kW)",			with: "100"
       				fill_in "Usage (in kWh)",			with: "10000"
       				fill_in "Bill Date (yyyy-mm-dd)",   with: "2013-10-01"
       				click_button "Submit"
				end

				it { should have_title('Input') }
				it { should_not have_title('Bill Comparison') }
		        it { should have_selector('div.alert.alert-notice', text: 'Zip Code is currently not supported.') }

		        it "emails invalid zip code to support@gulchsolutions.com" do
		        
			        last_email.to.should eq(["support@gulchsolutions.com"])

		        end

			end

			describe "with zip code outside permissions area" do

		        #it "emails new user info to info@gulchsolutions.com" do

		        #  last_email.to.should eq(["info@gulchsolutions.com"])
		        
		        #end

			end

			describe "with other invalid data" do

				before do
					fill_in "Zip code",					with: "00000"
	       			select  "3-phase", 					from: "Phases"
    	   			fill_in "Demand (in kW)",			with: "-1"
       				fill_in "Usage (in kWh)",			with: "10000"
       				fill_in "Bill Date (yyyy-mm-dd)",   with: "2013-10-01"
       				click_button "Submit"
				end

				it { should have_title('Input') }
				it { should_not have_title('Bill Comparison') }
		        it { should have_selector('div.alert.alert-notice', text: 'Data input has returned an error.') }

			end

		end

		describe "after valid Input submission" do

			before do
       			fill_in "Zip code",      			with: "00000"
       			select  "3-phase", 					from: "Phases"
       			fill_in "Demand (in kW)",			with: "100"
       			fill_in "Usage (in kWh)",			with: "10000"
       			fill_in "Bill Date (yyyy-mm-dd)",  	with: "2013-10-01"
       			click_button "Submit"      			
    		end

			describe  "Tariff Tool page" do

				it { should have_title('Bill Comparison') }
				it { should_not have_content('Input Zip Code') }
				it { should_not have_title('Input') }

				it { should have_content('Billing Period:') }
				it { should have_content('kWh used = ') }
				it { should have_content('Billed Load in kW =') }
				it { should have_content('Rate:') }
				it { should have_content('Total Bill =') }

			end	
		end
	end
end
