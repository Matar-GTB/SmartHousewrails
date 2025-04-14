class CreateDeviceData < ActiveRecord::Migration[8.0]
  def change
    create_table :device_data do |t|
      t.references :device, null: false, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
