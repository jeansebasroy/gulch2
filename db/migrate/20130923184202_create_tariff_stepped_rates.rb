class CreateTariffSteppedRates < ActiveRecord::Migration
  def change
    create_table :tariff_stepped_rates do |t|
      t.string :unit
      t.float :start
      t.float :end
      t.float :rate
      t.string :city
      t.integer :tariff_line_item_id

      t.timestamps
    end
  end
end
