class TariffToolsController < ApplicationController
	before_action :signed_in_user

	def new
	end


	def create
		@site = Site.new(zip_code: params[:site][:zip_code], phases: params[:site][:phases],
						user_id: "1")

		if @site.save 
			@site_load_profile = SiteLoadProfile.new(meter_read_date: params[:site_load_profile][:bill_date],
						tou: "All",	demand: params[:site_load_profile][:demand_in_kW], 
						usage: params[:site_load_profile][:usage_in_kWh], site_id: @site.id)
	
			if @site_load_profile.save
			    
				@zip = Site.last.zip_code
				@demand = SiteLoadProfile.last.demand
				@usage = SiteLoadProfile.last.usage
				@date = SiteLoadProfile.last.meter_read_date
				@phases = Site.last.phases

				if TariffZipCode.zip_code(@zip).nil?
					flash[:notice] = "Zip Code is currently not supported. 
						Please contact sales@gulchsolutions.com for more information."
			    	redirect_to '/input'
				else
					flash[:notice] = "Electricity bill has been re-created."
			    	redirect_to '/tool'
			    end
			else
				render 'input'
			end
		else
			#redirect_to '/input'
			render 'input'
		end

	end
	
	def index
	end


	def input
		@site = Site.new
		@site_load_profile = SiteLoadProfile.new
	end

	def self.input
	end

end
