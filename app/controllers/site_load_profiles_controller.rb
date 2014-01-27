class SiteLoadProfilesController < ApplicationController
	before_action :signed_in_user

	def create
		@site = Site.find(params[:site_load_profile][:site_id])
		@site_load_profile = SiteLoadProfile.new(site_load_profile_params)

		# checks to see if a site_load_profile already matches on meter_read_date 
		@new_or_update = SiteLoadProfile.new_or_update(@site_load_profile.site_id, 
			@site_load_profile.meter_read_date)

		if @new_or_update[:status] == 'new'

			if @site_load_profile.save
				flash[:notice] = 'New Load Profile data added.'
				redirect_to site_load_profile_path(@site)
			else
				render 'show'
			end

		elsif @new_or_update[:status] == 'update'
			@site_load_profile = SiteLoadProfile.find(@new_or_update[:id])

  			if @site_load_profile.update(site_load_profile_params)
				flash[:notice] = 'Load Profile data updated.'
				redirect_to site_load_profile_path(@site)
			else
				render 'show'
			end

		elsif @new_or_update[:status] == 'error'
			flash[:notice] = 'An error has occured.  Our support team has 
				been made aware and will be fixing the problem shortly.'
			redirect_to site_load_profile_path(@site)
		end

	end

	def delete
		@site = Site.find(params[:site_id])
		@site_load_profile = SiteLoadProfile.find(params[:id])

		if @site_load_profile.destroy
			flash[:notice] = 'Site Load Profile data deleted.'
			redirect_to site_load_profile_path(@site)
		else
			flash[:notice] = 'An error has occured in an attempt to delete the Site Load Profile data.
							Support has been made aware and shall be in touch to address this issue.'
			# add email alert to support
			
		end

	end

	def edit
	end

	def export_usage_data
		#@site = Site.find(params[:id])
		#@site_load_profile = SiteLoadProfile.where('site_id = ?',
		#											'400')

		#csv << ["Meter Read Date", "Total Usage", "Total Demand"]
		#@site_load_profile.each do |site_load_profile|
		#	csv << [site_load_profile.meter_read_date, site_load_profile.total_usage, 
		#		site_load_profile.total_demand]
		#end
		

		#send_data(site_load_profile_csv, :type => 'text/csv', :filename => 'site_load_profile.csv')
		#send_data(student_csv, :type => 'text/csv', :filename => 'all_students.csv')


		#format.xls { send_data @site.to_xls(col_sep: "\t") }
	end

	def index
#		site_id = params[:site_id]
		
#		@site_load_profiles = SiteLoadProfile.order(:meter_read_date)

#		respond_to do |format|
#			format.html
#			format.csv { send_data @site_load_profiles.to_csv(site_id) }
#		end

	end

	def new
		@site_load_profile = SiteLoadProfile.new
	end

	def select_site
		#for storing selected_site information
		@site = Site.find(params[:site_id])
		session[:selected_site_id] = @site.id
		#flash[:notice] = session[:selected_site_id]
		redirect_to site_load_profile_path(@site)

	end

	def show
		@site = Site.find(params[:id])
		@site_load_profile = SiteLoadProfile.new
		@site_load_profiles = SiteLoadProfile.order(:meter_read_date).reverse_order

		respond_to do |format|
			format.html
			format.csv { send_data @site_load_profiles.to_csv(@site.id) }
		end
	end

	private

		def site_load_profile_params
			params.require(:site_load_profile).permit(:meter_read_date, :data_source,
						:all_usage, :on_peak_usage, :part_peak_usage, :off_peak_usage,
						:all_demand, :on_peak_demand, :part_peak_demand, :off_peak_demand,  
						:site_id)
		end

end

