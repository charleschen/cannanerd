class CreateStrainTags < ActiveRecord::Migration
  def change
    create_table :strain_tags do |t|
      t.integer :strain_id
      t.integer :tag_id

      t.timestamps
    end
    
    add_index :strain_tags, :strain_id
    add_index :strain_tags, :tag_id
    add_index :strain_tags, [:strain_id, :tag_id], :unique => true
  end
end
