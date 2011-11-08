class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :email,                      :null => false
      t.string :name,                       :null => false
      t.string :crypted_password,           :null => false
      t.string :password_salt,              :null => false
      t.string :persistence_token,          :null => false
      
      t.integer :login_count,               :null => false, :default => 0
      t.integer :failed_login_count,        :null => false, :default => 0
      
      t.string  :perishable_token,          :null => false
      t.float :lat
      t.float :lng

      t.string :current_login_ip

      t.timestamps
    end
  end
end
