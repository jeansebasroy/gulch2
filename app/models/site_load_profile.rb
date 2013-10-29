class SiteLoadProfile < ActiveRecord::Base
	belongs_to :site

	validates :meter_read_date, presence: true	
	validates :tou, presence: true				
	validates :demand, presence: true, numericality: true
	validates :usage, presence: true, numericality: true
	validates :site_id, presence: true

end
