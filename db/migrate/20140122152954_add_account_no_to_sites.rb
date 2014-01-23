class AddAccountNoToSites < ActiveRecord::Migration
  def change
    add_column :sites, :account_no, :string
  end
end
