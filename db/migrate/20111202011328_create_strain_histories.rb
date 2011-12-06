class CreateStrainHistories < ActiveRecord::Migration
  def change
    create_table :strain_histories do |t|
      t.integer :user_id
      t.text :list

      t.timestamps
    end
  end
end
