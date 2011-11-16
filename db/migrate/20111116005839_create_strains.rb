class CreateStrains < ActiveRecord::Migration
  def change
    create_table :strains do |t|
      t.string :name
      t.string :id_str
      t.text :description
      t.text :data

      t.timestamps
    end
  end
end
