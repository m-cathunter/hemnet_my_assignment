class AddMunicipalityIdToPrices < ActiveRecord::Migration[7.1]
  def change
    add_column :prices, :municipality_id, :integer, null: false, default: 0
    add_foreign_key :prices, :municipalities
    add_index :prices, :municipality_id
  end
end
