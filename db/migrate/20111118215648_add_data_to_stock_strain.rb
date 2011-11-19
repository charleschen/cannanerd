class AddDataToStockStrain < ActiveRecord::Migration
  def change
    add_column :stock_strains, :data, :text
    add_column :stock_strains, :available, :boolean, :default => true
  end
end
