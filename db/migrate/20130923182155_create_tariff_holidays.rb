class CreateTariffHolidays < ActiveRecord::Migration
  def change
    create_table :tariff_holidays do |t|
      t.string :name
      t.date :date
      t.integer :tariff_territory_id

      t.timestamps
    end
  end
end
