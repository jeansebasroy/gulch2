class UsageFetcherController < ApplicationController
	before_action :signed_in_user


	def create
		@usage_fetcher = UsageFetcher.new(usage_fetcher_params)

		#@usage_data = UsageFetcher.fetch_Canadiens
		
		account_no = @usage_fetcher.account_no
		zip_code = @usage_fetcher.zip_code
		user_id = current_user.id
		
		# checks zip_code for proper length & format
		if zip_code.length > 5 

			flash.now[:notice] = 'Zip Code is too long.'
			render new_usage_fetcher_path

		elsif zip_code =~ /\d{5}/
		
			if account_no.length > 10
			
				flash.now[:notice] = 'Account Number is too long.'
				render new_usage_fetcher_path

			elsif account_no =~ /\d{10}/

				@usage_fetch_site_id = UsageFetcher.fetch_IL_ComEd(account_no, zip_code, user_id)
					
				if @usage_fetch_site_id == 'Account Number is invalid.'
					
					flash.now[:notice] = 'ComEd was not able to find Account Number.  Check the Account Number and try again.'
					render new_usage_fetcher_path

				else

					#redirects user to 'show' page for 'site' for which usage data was just fetched
					redirect_to site_load_profile_path(:id => @usage_fetch_site_id), notice: 'Usage Data has been sucessfully downloaded from ComEd.'

					# for future expansion, save a Regex of the utility's account number format in the database
					# => when 'find' utility by looking at zip_code, also 'pull' Regex for account_no format
					# => allow multiple account_no formats to be input ('account_regex_1', 'account_regex_2', etc.)
					# => insert a 'N/A' when an additional Regex is not needed

				end
					
			else
			
				flash.now[:notice] = 'Account Number is not in correct format for ComEd'
				render new_usage_fetcher_path

			end

		else

			flash.now[:notice] = 'Zip Code is not in correct format.'
			#flash.now[:notice] = (zip_code =~ /\d{5}$/)
			render new_usage_fetcher_path

		end
		
	end

	def new
		@usage_fetcher = UsageFetcher.new
	end

	def show
		#@usage_fetcher = UsageFetcher.new
	end

	private
  		def usage_fetcher_params
    		params.require(:usage_fetcher).permit(:account_no, :zip_code)
  		end

end