class CreateStockStrains < ActiveRecord::Migration
  def change
    create_table :stock_strains do |t|
      t.integer :club_id
      t.integer :strain_id
      
      t.text :description
      

      t.timestamps
    end
    
    add_index :stock_strains, :strain_id
    add_index :stock_strains, :club_id
    add_index :stock_strains, [:club_id,:strain_id], :unique => true
  end
end
