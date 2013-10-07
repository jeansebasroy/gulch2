class CreateTariffLineItems < ActiveRecord::Migration
  def change
    create_table :tariff_line_items do |t|
      t.string :name
      t.string :line_item_type
      t.date :effective_date
      t.date :expiration_date
      t.float :rate
      t.string :tou_type
      t.integer :bill_group_order
      t.integer :tariff_tariff_id
      t.integer :tariff_season_id
      t.integer :tariff_bill_group_id

      t.timestamps
    end
  end
end
