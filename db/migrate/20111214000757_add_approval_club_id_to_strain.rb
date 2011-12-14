class AddApprovalClubIdToStrain < ActiveRecord::Migration
  def change
    add_column :strains, :approval_club_id, :integer
  end
end
