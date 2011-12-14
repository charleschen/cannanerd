class AddClubIdToStrain < ActiveRecord::Migration
  def self.up
    add_column :strains, :club_id, :integer
    drop_table :stock_strains
  end
  
  def self.down
    create_table :stock_strains do |t|
      t.integer :club_id
      t.integer :strain_id

      t.text :description


      t.timestamps
    end

    add_index :stock_strains, :strain_id
    add_index :stock_strains, :club_id
    add_index :stock_strains, [:club_id,:strain_id], :unique => true
    add_column :stock_strains, :data, :text
    add_column :stock_strains, :available, :boolean, :default => true
  end
end
