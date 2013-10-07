class TariffZipCode < ActiveRecord::Base
		has_many :tariff_territory_zip_code_rel,
				foreign_key: "tariff_zip_code_id"
end
