class AddStatusToDevices < ActiveRecord::Migration[8.0]
  def change
    add_column :devices, :status, :boolean, default: true
  end
end
