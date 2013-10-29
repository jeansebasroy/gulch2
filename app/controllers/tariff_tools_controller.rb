class TariffToolsController < ApplicationController
	before_action :signed_in_user

	def new
		#@tariff_tools = Site.new
	end


	def create
		@site = Site.new(zip_code: params[:site][:zip_code], phases: params[:site][:phases],
						user_id: "1")

		if @site.save 
			@site_load_profile = SiteLoadProfile.new(meter_read_date: params[:site][:bill_date],
						tou: "All",	demand: params[:site][:demand_in_kW], 
						usage: params[:site][:usage_in_kWh], site_id: @site.id)
	
			if @site_load_profile.save
			    flash[:notice] = "Electricity bill has been re-created."
			    redirect_to '/tool'
			else
				#this changed
				redirect '/input'
			end
		else
			#flash[:error] = 'WTF'
			#this changed
			redirect_to '/input'
		end

	end
	
	def index
	end

end
