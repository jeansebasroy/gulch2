class UsageFetcherController < ApplicationController
	before_action :signed_in_user


	def create
		@usage_fetcher = UsageFetcher.new(usage_fetcher_params)

		#@usage_data = UsageFetcher.fetch_Canadiens
		
		account_no = @usage_fetcher.account_no
		zip_code = @usage_fetcher.zip_code
		user_id = session[:user_id]
		@usage_data = UsageFetcher.fetch_IL_ComEd(account_no, zip_code, user_id)
												
		flash.now[:notice] = @usage_data		

		#flash.now[:notice] = "'Get Usage' is under development.  Check back in a few weeks."
		render new_usage_fetcher_path
# => redirect to the site_load_profile page for the site for which data was 'fetched'		
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