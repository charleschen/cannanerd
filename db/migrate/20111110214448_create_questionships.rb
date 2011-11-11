class CreateQuestionships < ActiveRecord::Migration
  def change
    create_table :questionships do |t|
      t.integer :answer_id
      t.integer :question_id

      t.timestamps
    end
    
    add_index :questionships, :answer_id
    add_index :questionships, :question_id
    add_index :questionships, [:question_id, :answer_id], :unique => true
  end
end
