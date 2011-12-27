class AddClubIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :club_id, :integer
  end
end
