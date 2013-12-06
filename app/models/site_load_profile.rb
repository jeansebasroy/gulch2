class SiteLoadProfile < ActiveRecord::Base
	belongs_to :site

	validates :meter_read_date, presence: true	
	validates :tou, presence: true				
	validates :demand, presence: true, numericality: true
	validates :usage, presence: true, numericality: true
	validates :site_id, presence: true

	# returns all the data that makes up a site's load profile
	def self.get_load_profile(site_id)
		@load_profile_pieces = SiteLoadProfile.where('site_id = ?', site_id)
		#@load_profile_pieces.sort_by{ |i| i.meter_read_date }
		#@load_profile_pieces.reverse

# => this does not
		@full_load_profile = Array.new

		@load_profile_pieces.each do |j|
		
			# checks to see if .meter_read_date has already been processed
			if @full_load_profile.find { |h| h.has_value? j.meter_read_date }

				current_hash = nil
			
			else		
			
				current_hash = { :meter_read_date => j.meter_read_date }
			
				# finds all the data associated with that .meter_read_date
				@load_profile_pieces.each do |k|

					if j.meter_read_date == k.meter_read_date

						# adds the value to the correct key in the full_load_profile
						case k.tou
						when 'All'
							current_hash[:all_usage] = k.usage 
							current_hash[:all_demand] = k.demand 

						when 'On-Peak'
							current_hash[:peak_usage] = k.usage 
							current_hash[:peak_demand] = k.demand 

						when 'Part-Peak'
							current_hash[:part_usage] = k.usage 
							current_hash[:part_demand] = k.demand 

						when 'Off-Peak'
							current_hash[:off_usage] = k.usage 
							current_hash[:off_demand] = k.demand 

						else
							# need to fix this to handle when interval data is input
							#current_hash = { :meter_read_date => 'Interval' }

						end

					end

				end
			
			end

			if current_hash.nil?

			else
				
				@full_load_profile += [ current_hash ]

			end

		end

		@full_load_profile
		@full_load_profile.sort_by!{ |i| i[:meter_read_date] }
		@full_load_profile.reverse!

	end

end
