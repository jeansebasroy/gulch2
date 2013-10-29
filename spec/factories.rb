FactoryGirl.define do 

	factory :user do
		first_name	"J.S."
		last_name	"Roy"
		email		"jroy@example.com"
		phone       "555-867-5309"
		company		"Acme Inc"
		address     "123 Main Street"
		city        "Any Town"
		state		"IL"
		zip			"60607"
		password	"foobar"
		password_confirmation	"foobar"

	end

	#factory :site do
	#	site_name		"Test Site"
	#	company 		"Acme Inc."
	#	industry_type 	"Commercial"
	#	building_type 	"Office"
	#	description 	"Standard office building"
	#	address 		"123 Main St"
	#	city 			"Any Town"
	#	state 			"IL"
	#	zip_code 		"60607"
	#	square_feet 	"3000"
	#	phases 			"3-phase"
	#	is_site_saved 	""
	#	user
	#end

end