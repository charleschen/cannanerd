class AddPositionToQuestionsAndQuiziations < ActiveRecord::Migration
  def change
    add_column :questions, :position, :integer
    add_column :quiziations, :position, :integer
  end
end
