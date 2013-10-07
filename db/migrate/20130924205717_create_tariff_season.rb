class CreateTariffSeason < ActiveRecord::Migration
  def change
    create_table :tariff_season do |t|
      t.string :season_type
      t.date :start_date
      t.date :end_date_date
      t.integer :tariff_territory_id

      t.timestamps
    end
  end
end
