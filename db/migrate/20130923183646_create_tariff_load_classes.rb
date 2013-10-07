class CreateTariffLoadClasses < ActiveRecord::Migration
  def change
    create_table :tariff_load_classes do |t|
      t.string :name
      t.string :customer_type
      t.string :voltage
      t.string :units
      t.float :start
      t.float :end
      t.string :weather_zone
      t.integer :tariff_territory_id

      t.timestamps
    end
  end
end
