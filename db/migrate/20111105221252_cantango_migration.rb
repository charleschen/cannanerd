class CantangoMigration < ActiveRecord::Migration
  def up
    add_column :users, :roles_mask, :integer
    add_column :clubs, :roles_mask, :integer
  end

  def down
    remove_column :users, :roles_mask
    remove_column :clubs, :roles_maks
  end
end
