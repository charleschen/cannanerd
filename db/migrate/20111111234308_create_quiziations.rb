class CreateQuiziations < ActiveRecord::Migration
  def change
    create_table :quiziations do |t|
      t.integer :quiz_id
      t.integer :question_id
      t.string :answers_hash, :default => "{}"

      t.timestamps
    end
    
    add_index :quiziations, :quiz_id
    add_index :quiziations, :question_id
    add_index :quiziations, [:quiz_id, :question_id], :unique => true
  end
end
