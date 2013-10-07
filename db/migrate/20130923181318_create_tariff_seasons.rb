class CreateTariffSeasons < ActiveRecord::Migration
  def change
    create_table :tariff_seasons do |t|
      t.string :type
      t.date :start_date
      t.date :end_date
      t.integer :tariff_territory_id

      t.timestamps
    end
  end
end
