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
					TariffMailer.zip_db_missing(@site).deliver
					flash[:notice] = "Zip Code is currently not supported. 
						Please contact sales@gulchsolutions.com for more information."
			    	redirect_to '/input'
			    
			    elsif (TariffTerritory.territory(@zip).nil? || TariffUtility.utility(@zip).nil? || 
			    		(TariffSeason.season(@date, @zip).count < 2) || 
			    		(TariffBillingClass.billing_class(@zip, @demand, @usage, @phases).count != 1) )

			    	TariffMailer.database_error(@site, @site_load_profile).deliver
					flash[:notice] = "Data input has returned an error.  Verify the data input and try again. 
						Contact support@gulchsolutions.com for more details."
			    	#flash[:notice] = "Data input has resulted in an invalid Territory, Utility, Season, or Billing Class."
			    	redirect_to '/input'

				else 
			    	@territory = TariffTerritory.territory(@zip)
					@utility = TariffUtility.utility(@zip)
					@season = TariffSeason.season(@date, @zip)
					@billing_class = TariffBillingClass.billing_class(@zip, @demand, @usage, @phases)

					if (TariffTou.tou(@date, @zip).nil? || TariffMeterRead.meter_read(@date, @zip).nil? ||
						TariffTariff.tariffs(@billing_class).nil? || TariffBillGroup.bill_groups(@billing_class).nil?)

						TariffMailer.database_error(@site, @site_load_profile).deliver
						flash[:notice] = "Data input has returned an error.  Verify the data input and try again.  
							Contact support@gulchsolutions.com for more details."
				    	#flash[:notice] = "Data input has resulted in an invalid Tariff or Bill Group."
				    	redirect_to '/input'

					else

						@meter_read = TariffMeterRead.meter_read(@date, @zip)
						@tou = TariffTou.tou(@date, @zip)
						@tariffs = TariffTariff.tariffs(@billing_class)
						@bill_groups = TariffBillGroup.bill_groups(@billing_class)

						if TariffLineItems.line_items(@tariffs, @date, @season).nil?

							TariffMailer.database_error(@site, @site_load_profile).deliver
							flash[:notice] = "Data input has returned an error.  Verify the data input and try again.  
								Contact support@gulchsolutions.com for more details."
					    	#flash[:notice] = "Data input has resulted in an invalid Line Items."
					    	redirect_to '/input'

					    else
					
					    	flash[:notice] = "Electricity bill has been re-created."
					    	redirect_to '/tool'
					
					    end

				    end

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
