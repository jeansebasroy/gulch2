class TariffBillGroup < ActiveRecord::Base
	belongs_to :tariff_billing_class
	has_many :tariff_line_items, 
				foreign_key: "tariff_bill_group_id"
	validates :tariff_billing_class, presence: true

	# Pulls the applicable bill groups based on tariff
	def self.bill_groups(billing_class)
		@bill_groups = TariffBillGroup.where('tariff_billing_class_id = ?',
			billing_class[0].id)
	end

	# need to error trap if more than one billing class record is passed

end
