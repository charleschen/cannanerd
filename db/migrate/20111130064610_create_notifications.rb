class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :content
      t.boolean :unread, :default => true
      t.integer :user_id
      t.text    :redirect

      t.timestamps
    end
  end
end
