class UsageFetcherController < ApplicationController
	before_action :signed_in_user


	def create
		@usage_fetcher = UsageFetcher.new(usage_fetcher_params)

		#@usage_data = UsageFetcher.fetch_Canadiens
		
		account_no = @usage_fetcher.account_no
		zip_code = @usage_fetcher.zip_code
		user_id = current_user.id
		@usage_fetch_site_id = UsageFetcher.fetch_IL_ComEd(account_no, zip_code, user_id)
		

		#@usage_fetch_site_id = '400'
		#@usage_fetch_site_id = user_id

		#tests what gets returned from method
		#if @usage_fetch_site_id.nil?
		#	flash.now[:notice] = 'Nothing returned'
		#else
		#	flash.now[:notice] = @usage_fetch_site_id
		#end
		#render new_usage_fetcher_path

		#redirects user to 'show' page for 'site' for which usage data was just fetched
		redirect_to site_load_profile_path(:id => @usage_fetch_site_id), notice: 'Usage Data has been sucessfully downloaded from ComEd.'

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