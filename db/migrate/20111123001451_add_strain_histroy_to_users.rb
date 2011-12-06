class AddStrainHistroyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :top_strains, :text
  end
end
