class CreateRelatedTags < ActiveRecord::Migration
  def change
    create_table :related_tags do |t|
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
    
    add_index :related_tags, :user_id
    add_index :related_tags, :tag_id
    add_index :related_tags, [:user_id,:tag_id], :unique => true
  end
end
