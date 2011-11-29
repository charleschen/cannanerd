class AddTagListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tag_list, :text
  end
end
