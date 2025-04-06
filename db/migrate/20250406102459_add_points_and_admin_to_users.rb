class AddPointsAndAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :points, :integer, default: 0
    add_column :users, :admin, :boolean, default: false
  end
end
