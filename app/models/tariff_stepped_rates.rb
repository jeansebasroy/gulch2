class TariffSteppedRates < ActiveRecord::Base
	belongs_to :tariff_line_items
	has_many :tariff_line_items, 
				foreign_key: "tariff_line_item_id"
	validates :tariff_line_items_id, presence: true

	# Pulls the applicable stepped rates based on the line item
	def self.stepped_rates(line_item_id)
		@stepped_rates = TariffSteppedRates.where('tariff_line_item_id = ?',
			line_item_id)

	end

	# Pulls the applicable line item based on tariff
#	def self.line_items(tariffs, date, season)
#		@line_items = TariffLineItems.where('(tariff_tariff_id = ? OR tariff_tariff_id = ?) 
#				AND effective_date <= ? AND (expiration_date >= ? OR expiration_date isnull)
#				AND (tariff_season_id = ? OR tariff_season_id = ?)',
#				tariffs[0].id, tariffs[1].id, date, date, season[0].id, season[1].id)
#
#	end

end
