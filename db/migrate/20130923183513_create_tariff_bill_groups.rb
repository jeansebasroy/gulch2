class CreateTariffBillGroups < ActiveRecord::Migration
  def change
    create_table :tariff_bill_groups do |t|
      t.string :name
      t.integer :order
      t.integer :tariff_billing_class_id

      t.timestamps
    end
  end
end
