class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.integer :per_page, :default => 4
      
      t.timestamps
    end
  end
end
