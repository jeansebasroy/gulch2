class SiteLoadProfilesController < ApplicationController
	before_action :signed_in_user

	def new
		@site_load_profile = SiteLoadProfile.new
	end

	def create
		@site = Site.find(params[:site_load_profile][:site_id])
		@site_load_profile = SiteLoadProfile.new(site_load_profile_params)

		if @site_load_profile.save
			flash[:notice] = 'New Load Profile data added.'
			redirect_to site_load_profile_path(@site)
			#redirect_to '/input'
		else
			render 'show'
		end

		#redirect_to '/input'

	end

	def show
		@site = Site.find(params[:id])
		@site_load_profile = SiteLoadProfile.new
	end

	def edit
	end

	def destroy
	end


	private

		def site_load_profile_params
			params.require(:site_load_profile).permit(:meter_read_date, :tou, 
						:demand, :usage, :interval_date_time, :site_id)
		end

end

#	def show
#		@site = Site.find(params[:id])
		#@user = User.find(params[:id])
#	end

