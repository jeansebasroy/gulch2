class TariffSeason < ActiveRecord::Base
	belongs_to :tariff_territory
	has_many :tariff_tou,
				foreign_key: "tariff_tou_id"
	validates :tariff_territory_id, presence: true


	# returns the type of season based on date and zip code
	def self.season(date, zip)
		@tariff_territory = TariffTerritory.territory(zip)
		@season = TariffSeason.where('tariff_territory_id = ? AND start_date <= ? 
			AND end_date >= ?', 
			@tariff_territory.id, date, date)

	end


end

