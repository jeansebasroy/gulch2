class CreateTariffLmpRates < ActiveRecord::Migration
  def change
    create_table :tariff_lmp_rates do |t|
      t.date :date
      t.time :time
      t.float :factor
      t.integer :tariff_iso_lmp_id

      t.timestamps
    end
  end
end
