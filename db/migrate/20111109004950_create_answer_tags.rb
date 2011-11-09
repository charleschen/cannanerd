class CreateAnswerTags < ActiveRecord::Migration
  def change
    create_table :answer_tags do |t|
      t.integer :answer_id
      t.integer :tag_id

      t.timestamps
    end
    
    add_index :answer_tags, :answer_id
    add_index :answer_tags, :tag_id
    
    add_index :answer_tags, [:answer_id, :tag_id], :unique => true
  end
end
