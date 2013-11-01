FactoryGirl.define do 

	factory :user do
		first_name				"Test"
		sequence(:last_name)	{ |n| "Test#{n}"}
		sequence(:email)		{ |n| "test#{n}@example.com" }
		phone       			"555-867-5309"
		company					"Acme Inc"
		address     			"123 Main Street"
		city        			"Any Town"
		state					"IL"
		zip						"60607"
		password				"foobar"
		password_confirmation	{ |u| u.password }
	end

	factory :site do
		site_name		"Test Site"
		company 		"Acme Inc."
		industry_type 	"Commercial"
		building_type 	"Office"
		description 	"Standard office building"
		address 		"123 Main St"
		city 			"Any Town"
		state 			"NJ"
		zip_code 		"07004"
		square_feet 	"3000"
		phases 			"3-phase"
		is_site_saved 	""
		user
	end

	factory :site_load_profile do
		meter_read_date	"10/1/2013"
		tou				"All"
		demand			"100"
		usage			"10000"
		site
	end

	factory :tariff_utility do
		id 				1
		utility_name	"JCP&L"
		state			"NJ"
	end

	factory :tariff_territory do
		territory_name	"JCP&L"
		tariff_utility
	end

	factory :tariff_zip_code do
		zip_code 		07004
	end

	factory :tariff_territory_zip_code_rel do
		tariff_territory
		tariff_zip_code
	end

end