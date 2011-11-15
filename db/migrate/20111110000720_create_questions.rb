class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :questionnaire_id
      
      t.boolean :multichoice, :default => false

      t.timestamps
    end
  end
end
