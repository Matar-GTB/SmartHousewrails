class AddDeletionRequestedToDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :deletion_requested, :boolean, default: false
  end
end
