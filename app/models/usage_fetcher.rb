class UsageFetcher < ActiveRecord::Base
	validates :account_no, presence: true
	validates :zip_code, numericality: true, 
				length: {minimum: 5, maximum: 5}

	def self.zip_code(zip)
		@zip_code = TariffZipCode.find_by(zip_code: zip)

	end
	
	def self.fetch_IL_ComEd(account_no, zip_code, user_id)
		#this code scrapes the "View Usage Data" after submitting the account_no on the ComEd PowerPath website
		# the usage data is written to the database
		require 'watir-webdriver'
		require 'nokogiri'
		require 'open-uri'
		require 'phantomjs'

		#submits account number to ComEd to get to Usage Data
		browser = Watir::Browser.new :phantomjs
		# => headless browser
		#browser = Watir::Browser.new 
		# => with Firefox (can see what's happening)

		browser.goto 'https://www.comed.com/customer-service/rates-pricing/customer-choice/Pages/usage-data.aspx'

		browser.radio(:value => '1').set

		browser.text_field(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_AccountNumber').set account_no

		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_Addbtn').click
		
		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_ViewUsagebtn').click

		# => if an invalid account_no is submitted, a new browser window is not opened, and this is where the program breaks
		data = Nokogiri::HTML.parse(browser.html)

		is_account_no_valid = data.css('#ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_lblValMsg').text

		if is_account_no_valid == 'Account number is not valid.'

			# closes the opened window
			browser.window(:title => "Usage Data | ComEd - An Exelon Company").use
			browser.close

			'Account Number is invalid.'

		else

			#points Nokogiri to the newly opened browser window
			browser.window(:title => "| ComEd - An Exelon Company").use
			data = Nokogiri::HTML.parse(browser.html)

			#scrapes data for site
			supply_group = data.at_css(':nth-child(5) td.noborder').text
			
			#checks to see if a site with the given account_no exists
	# => use user_id to verify that user has access to that 'site'; check if user_id is admin, etc.
			@usage_fetch_site_id = '401'

			existing_site = Site.where('user_id = ? AND account_no = ? AND zip_code = ?',
										user_id, account_no, zip_code)
			
			if existing_site.count == 0
				#creates new site if one does not match the criteria
				site_of_account_no = Site.new(:user_id => user_id, :site_name => 'Usage_Fetcher',
											:account_no => account_no, :zip_code => zip_code, 
											:is_site_saved => true)
				site_of_account_no.save

				@usage_fetch_site_id = site_of_account_no.id
				#@usage_fetch_site_id = '402'
				#@usage_fetch_site_id = existing_site.count

			else
				site_of_account_no = existing_site.last

				@usage_fetch_site_id = existing_site.last.id
				#@usage_fetch_site_id = '403'

			end

			#scrapes data for site_load_profile
			#determines the number of meter_read_dates
			meter_read_date = data.css(':nth-child(6) td:nth-child(2)')

			# cycles through every meter_read_date
			j = 0

			meter_read_date.each do |i|
				# usage data
				total_kwh_usage = data.css(':nth-child(6) td:nth-child(4)')[j].text
				on_peak_kWh_usage = data.css(':nth-child(6) td:nth-child(5)')[j].text
				off_peak_kwh_usage = data.css(':nth-child(6) td:nth-child(6)')[j].text

				# demand data
				billing_demand = data.css(':nth-child(6) td:nth-child(7)')[j].text

				# meter_read_date in right format
				month = i.text[0..1]
				day = i.text[3..4]
				year = i.text[6..9]
				formatted_meter_read_date = year + '-' + month + '-' + day

				#checks to see if a site_load_profile with the current meter_read_date exists for that site
				existing_site_load_profile = SiteLoadProfile.where('site_id = ? AND meter_read_date =?',
																	site_of_account_no.id, formatted_meter_read_date)

				if existing_site_load_profile.count == 0
					#creates new site_load_profile for newly created site with usage data pulled from ComEd PowerPath
					site_load_profile = SiteLoadProfile.new(:meter_read_date => formatted_meter_read_date, :all_usage => total_kwh_usage,
															:on_peak_usage => on_peak_kWh_usage, :off_peak_usage => off_peak_kwh_usage, 
															:all_demand => billing_demand,
															:site_id => site_of_account_no.id, :data_source => 'Monthly')		
					site_load_profile.save

				else
					#updates existing record
					existing_site_load_profile.last.update(:meter_read_date => formatted_meter_read_date, :all_usage => total_kwh_usage,
															:on_peak_usage => on_peak_kWh_usage, :off_peak_usage => off_peak_kwh_usage, 
															:all_demand => billing_demand,
															:site_id => site_of_account_no.id, :data_source => 'Monthly')

	# => give the user the option to select whether or not to over-write existing data (for future development)
				
				end

				#increments j
				j += 1

			end

			#closes windows that have been opened
			browser.window(:title => "| ComEd - An Exelon Company").use
			browser.window.close

			browser.window(:title => "Usage Data | ComEd - An Exelon Company").use		
			browser.close

			#returns something
			site_of_account_no.id
			
		end

	end

	def self.fetch_Canadiens
		require 'nokogiri'
		require 'open-uri'
		
		#for testing nokogiri functionality
		url = 'http://en.wikipedia.org/wiki/Montreal_Canadiens'

		data = Nokogiri::HTML(open(url))

		data.at_css("ul:nth-child(51) li:nth-child(3)").text

	end

	def self.fetch_IL_test(account_no)
		#template for how Mechanize works
		require 'mechanize'
		require 'nokogiri'
		require 'open-uri'
		require 'openssl'

		#ComEd_PowerPath ='https://www.comed.com/customer-service/rates-pricing/customer-choice/Pages/usage-data.aspx'
		#@ComEd_PowerPath ='https://www.comed.com/customer-service/Pages/default.aspx'

		agent = Mechanize.new
		page = agent.get('https://www.comed.com/customer-service/rates-pricing/customer-choice/Pages/usage-data.aspx')
		#agent.form.radiobutton_with(:id => '#ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_RequestOption_0').check
		#account_input = page.form.radiobuttons_with(:name => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_RequestOption').first
		#account_input = page.form.radiobuttons_with(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_RequestOption')
		#account_input = page.form.radiobuttons_with(:value => 1)
		#page.form.radiobuttons_with(:value => 1).click
		#page.form.radiobutton_with(:id => '0x2491dac').checked = true
		#agent.page.form.radiobutton.checked = true
		page.form.radiobuttons.first.check
		page.form.radiobuttons.first.click

		#account_input.click

		if is_it_check.nil?
			result = 'We have an issue.'

		else
			result = is_it_check
			#account_input = page.form.field_with(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_AccountNumber')
			#account_input = page.form.field_with(:name => 'AccountNumber')

			#account_input.value = account_no
			#page.submit
			#page.form.button_with(:name => 'Add')


			#result = "So far so good"
			#result = account_no
		end
	end


	def self.fetch_IL_ComEd_download(account_no)
		# this code pushes the 'Download CSV File' after submitting the account number on the ComEd PowerPath website
# => the download disappears once the browser window is closed		
		require 'headless'
		require 'watir-webdriver'
		require 'nokogiri'
		require 'open-uri'

		#submits account number to ComEd to get to Usage Data
		browser = Watir::Browser.new
		browser.goto 'https://www.comed.com/customer-service/rates-pricing/customer-choice/Pages/usage-data.aspx'
		browser.radio(:value => '1').set
		
		browser.text_field(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_AccountNumber').set account_no
		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_Addbtn').click
		
		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_Downloadbtn').click

		#closes ComEd PowerPath window
		browser.window(:title => "Usage Data | ComEd - An Exelon Company").use
		browser.window.close

	end

# => this code works, but for the month and day in meter_read_date are swapped
	def self.fetch_IL_ComEd_saved(account_no, zip_code)
		#this code pushed the "View Usage Data" after submitting the account_no on the ComEd PowerPath website
		# need to get this code to write to the database
		require 'headless'
		require 'watir-webdriver'
		require 'nokogiri'
		require 'open-uri'

		#submits account number to ComEd to get to Usage Data
		browser = Watir::Browser.new
		
		browser.goto 'https://www.comed.com/customer-service/rates-pricing/customer-choice/Pages/usage-data.aspx'

		browser.radio(:value => '1').set

		browser.text_field(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_AccountNumber').set account_no

		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_Addbtn').click
		
		browser.link(:id => 'ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_ViewUsagebtn').click

		#points Nokogiri to the newly opened browser window
		browser.window(:title => "| ComEd - An Exelon Company").use
		data = Nokogiri::HTML.parse(browser.html)

		#scrapes Usage Data from the page
		
		#scrapes data for site
		supply_group = data.at_css(':nth-child(5) td.noborder').text
		
		#creates new site
		site_of_account_no = Site.new(:user_id => 1, :site_name => 'Usage_Fetcher',
										:account_no => account_no, :zip_code => zip_code)
		site_of_account_no.save

		#checks to see if a site with the given account_no exists
# => add zip_code too, before go into production
#		@site_of_account_no = Site.where('account_no = ? AND zip_code = ?',
#							account_no, zip_code)

		#if @site_of_account_no.count == 0
		#	@site_of_account_no = Site.new(:account_no => account_no, :zip_code => zip_code)
		#else
		#	@site_of_account_no.first
		#end	

		#scrapes data for site_load_profile
		
		#determines the number of meter_read_dates

		#meter_read_date = data.css(':nth-child(6) tr:nth-child(1) td:nth-child(2)').text
		meter_read_date = data.css(':nth-child(6) td:nth-child(2)')
# => need to flip month & day when it gets written to database		
			#meter_read_date_2 = data.at_css(':nth-child(6) tr:nth-child(2) td:nth-child(2)').text

		# cycles through every meter_read_date
		j = 0

		meter_read_date.each do |i|
			# usage data
			total_kwh_usage = data.css(':nth-child(6) td:nth-child(4)')[j].text
			on_peak_kWh_usage = data.css(':nth-child(6) td:nth-child(5)')[j].text
			off_peak_kwh_usage = data.css(':nth-child(6) td:nth-child(6)')[j].text

			# demand data
			billing_demand = data.css(':nth-child(6) td:nth-child(7)')[j].text

			#create new site_load_profile for newly created site with usage data pulled from ComEd PowerPath
			site_load_profile = SiteLoadProfile.new(:meter_read_date => i.text, :all_usage => total_kwh_usage,
													:on_peak_usage => on_peak_kWh_usage, :off_peak_usage => off_peak_kwh_usage, 
													:all_demand => billing_demand,
													:site_id => site_of_account_no.id, :data_source => 'Monthly')
			site_load_profile.save

			#increments j
			j += 1

		end

		#closes windows that have been opened
		browser.window(:title => "| ComEd - An Exelon Company").use
		browser.window.close

		browser.window(:title => "Usage Data | ComEd - An Exelon Company").use
		browser.window.close
		
		#returns something
		j
		
	end



end
