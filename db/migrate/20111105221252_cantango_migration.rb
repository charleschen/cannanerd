class CantangoMigration < ActiveRecord::Migration
  def up
    add_column :users, :roles_mask, :integer, :default => 1    # by default user is unverified
    add_column :clubs, :roles_mask, :integer, :default => 1    # be default user is unregistered
  end

  def down
    remove_column :users, :roles_mask
    remove_column :clubs, :roles_maks
  end
end
