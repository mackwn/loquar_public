class AddPointsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :points, :float, default: 0
  end
end
