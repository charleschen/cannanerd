class AddDataToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :data, :text, :default => "{}"
  end
end
