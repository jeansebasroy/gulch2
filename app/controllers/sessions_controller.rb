class SessionsController < ApplicationController

	def new
	end

	def create
		if params[:session][:zip_code].present?
			session[:zip_code] = params[:session][:zip_code]
			session[:demand_in_kW] = params[:session][:demand_in_kW]
			session[:usage_in_kWh] = params[:session][:usage_in_kWh]
			session[:bill_date] = params[:session][:bill_date]
			session[:phases] = params[:session][:phases]

			redirect_to tool_path

		else
			user = User.find_by(email: params[:session][:email].downcase)
			if user && user.authenticate(params[:session][:password])
				sign_in user
				redirect_to '/input'
			else
				flash.now[:error] = 'Invalid email/password combination'
				render 'new'
			end
					
		end
	end

	def destroy
	end

end
