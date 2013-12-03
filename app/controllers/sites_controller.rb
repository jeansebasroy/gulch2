class SitesController < ApplicationController
	before_action :signed_in_user

	def new
		@site = Site.new
	end

	def create
		@site = Site.new(site_params)
		#@site.user_id = @user.id

		if @site.save
			redirect_to current_user
		else
			render 'new'
		end
	end

	def edit
	end

	def destroy
	end

	private

	  	def site_params
	  		params.require(:site).permit(:site_name, :company, 
	  						:industry_type, :building_type, :description, 
	  						:address, :city, :state, :zip_code, :square_feet, 
	  						:phases, :user_id)
	  	end

end
