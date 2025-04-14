class AddUniqueIdToDevices < ActiveRecord::Migration[8.0]
  def change
    add_column :devices, :unique_id, :string
  end
end
