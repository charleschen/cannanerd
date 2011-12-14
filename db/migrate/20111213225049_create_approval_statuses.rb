class CreateApprovalStatuses < ActiveRecord::Migration
  def change
    create_table :approval_statuses do |t|
      t.integer :states_mask, :default => 1    # by default approval state is in waiting state
      
      t.integer :strain_id
      t.integer :stock_strain_id
      
      t.text :comment
      

      t.timestamps
    end
  end
end
