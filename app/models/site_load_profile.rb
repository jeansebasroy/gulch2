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
		@load_profile_pieces.sort_by{ |i| i.meter_read_date }
		#@load_profile_pieces.reverse


# => this works
# => this does not
#		@full_load_profile = Array.new
#		old_date = nil

#		@load_profile_pieces.each do |j|
			
#			if j.meter_read_date != '01/10/2013' 
#				current_hash = { :meter_read_date => j.meter_read_date }
#				old_date = j.meter_read_date	
#			end

			#current_hash[:all_usage] = j.usage	

			# adds the value to the correct key in the full_load_profile
#			case j.tou
#			when 'All'
#				current_hash[:all_usage] = j.usage 
#				current_hash[:all_demand] = j.demand 

#			when 'On-Peak'
#				current_hash[:peak_usage] = j.usage 
#				current_hash[:peak_demand] = j.demand 

#			when 'Part-Peak'
#				current_hash[:part_usage] = j.usage 
#				current_hash[:part_demand] = j.demand 

#			when 'Off-Peak'
#				current_hash[:off_usage] = j.usage 
#				current_hash[:off_demand] = j.demand 

#			else

#			end

#			@full_load_profile += [ current_hash ]

#		end

#		@full_load_profile
#		@full_load_profile.sort_by{ |i| i[:meter_read_date] }
#		@full_load_profile.reverse


# => this does not
		@full_load_profile = Array.new
		
		old_date = nil

		@load_profile_pieces.each do |j|
		
# => here's where I need to figure this out
		# => I need to create the current_hash with the :meter_read_date every time the
		# 		j.meter_read_date is new or different
		# => if the j.meter_read_date is not new, it should not create a new hash, 
		#		it should continue adding the data to the existing hash, and 
		#  		it should only add the has to the @full_load_profile array before it creates a new hash
		
			#if j.meter_read_date == old_date 
				current_hash = { :meter_read_date => j.meter_read_date }
			
			#else
			#	current_hash = { :meter_read_date => j.meter_read_date }
			#	current_hash = { :meter_read_date => nil }	
				old_date = j.meter_read_date	
			
			#end

			# adds the value to the correct key in the full_load_profile
			case j.tou
			when 'All'
				current_hash[:all_usage] = j.usage 
				current_hash[:all_demand] = j.demand 

			when 'On-Peak'
				current_hash[:peak_usage] = j.usage 
				current_hash[:peak_demand] = j.demand 

			when 'Part-Peak'
				current_hash[:part_usage] = j.usage 
				current_hash[:part_demand] = j.demand 

			when 'Off-Peak'
				current_hash[:off_usage] = j.usage 
				current_hash[:off_demand] = j.demand 

			else
				# need to fix this to handle when interval data is input
				#current_hash = { :meter_read_date => 'Interval' }

			end

			@full_load_profile += [ current_hash ]


#while conditional [do]
#   code
#end

		end

		@full_load_profile
		@full_load_profile.sort_by{ |i| i[:meter_read_date] }
		@full_load_profile.reverse


		


		# update an element of the array (of a has)
		#@full_load_profile[2] = [ { :meter_read_date => '3/3/2013', :all_usage => '3' } ] 


		# update an element of a hash inside an array
		#@full_load_profile[2] = { :meter_read_date => '4/4/2014' }


#		@full_load_profile = Array.new
#		hash = {:meter_read_date => nil, 
#				:all_usage => nil, :peak_usage => nil, :part_usage => nil, :off_demand => nil,
#		 		:all_demand => nil, :peak_demand => nil, :part_demand => nil, :off_demand => nil}
#		@full_load_profile.push(hash)

#		@full_load_profile[1][:meter_read_date => '11/1/2011']

#		k = 0

#		@load_profile_pieces.each do |j|

			# checks to see if meter_read_date of new record is alreay in full_load_profile			
#			if j.meter_read_date == full_load_profile[:meter_read_date]

#			else
#				@full_load_profile.push(hash)	
#				k += 1
#				full_load_profile[k][:meter_read_date] = j.meter_read_date
#			end

			# adds the value to the correct key in the full_load_profile
#			case j.tou
#			when 'All'
#				full_load_profile[k][:all_usage] = j.usage
#				full_load_profile[k][:all_demand] = j.demand
#			when 'On-Peak'
#				full_load_profile[k][:peak_usage] = j.usage
#				full_load_profile[k][:peak_demand] = j.demand
#			when 'Part-Peak'
#				full_load_profile[k][:part_usage] = j.usage
#				full_load_profile[k][:part_demand] = j.demand
#			when 'Off-Peak'
#				full_load_profile[k][:off_usage] = j.usage
#				full_load_profile[k][:off_demand] = j.demand
#			else
				# need to fix this to handle when interval data is input
#				full_load_profile[k][:meter_read_date] = "Interval"
#			end

#		end

	end

end
