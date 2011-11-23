class AddStrainHistroyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :top_strains, :text
    add_column :users, :strain_history, :text
  end
end
