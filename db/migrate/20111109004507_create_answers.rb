class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content
      t.text :old_content

      t.timestamps
    end
  end
end
