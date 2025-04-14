class AddLevelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :level, :string, default: "simple"
  end
end
