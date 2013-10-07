class TariffTerritory < ActiveRecord::Base
	belongs_to :tariff_utility
	has_many :tariff_territory_zip_code_rel,
				foreign_key: "tariff_territory_id"
	validates :tariff_utility_id, presence: true

	# Pulls the territory based on a zip code
	def self.territory(zip)
		@zip_code = TariffZipCode.find_by(zip_code: zip)
		@zip_territory_rel = TariffTerritoryZipCodeRel.find_by(tariff_zip_code_id: 
			@zip_code.id)
		@territory = TariffTerritory.find_by(id: @zip_territory_rel.tariff_territory_id)

		# need to check if more than one record is returned

	end
	
end
