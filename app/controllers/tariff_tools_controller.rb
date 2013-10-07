class TariffToolsController < ApplicationController

	def index
	end

	def create
		@zip = params[:tariff_input][:zip_code]
		#session[:demand_in_kW] = params[:session][:demand_in_kW]
		#session[:usage_in_kWh] = params[:session][:usage_in_kWh]
		#session[:bill_date] = params[:session][:bill_date]
		#session[:phases] = params[:session][:phases]

		redirect_to tool_path
	end

end
