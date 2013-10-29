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
			    flash[:sucess] = "The electricity bill has been created."
			    redirect_to '/tool'
			else
				flash[:error] = 'WTF'
				
				redirect_to '/input'
			end
		else
			#flash[:error] = 'WTF'
			redirect_to '/input', :flash => { :error => "WTF" }
		end

	end
	
	def index
	end

end
