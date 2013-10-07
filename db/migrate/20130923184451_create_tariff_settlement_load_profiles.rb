class CreateTariffSettlementLoadProfiles < ActiveRecord::Migration
  def change
    create_table :tariff_settlement_load_profiles do |t|
      t.string :date
      t.time :time
      t.float :factor
      t.integer :tariff_load_class_id

      t.timestamps
    end
  end
end
