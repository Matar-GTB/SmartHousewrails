class AddLocationToDevices < ActiveRecord::Migration[8.0]
  def change
    add_column :devices, :location, :string
  end
end
