class CreateAnswerships < ActiveRecord::Migration
  def change
    create_table :answerships do |t|
      t.integer :answer_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :answerships, :answer_id
    add_index :answerships, :user_id
    
    add_index :answerships, [:user_id,:answer_id], :unique => true
  end
end
