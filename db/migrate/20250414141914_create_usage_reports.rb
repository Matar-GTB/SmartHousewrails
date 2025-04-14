class CreateUsageReports < ActiveRecord::Migration[8.0]
  def change
    create_table :usage_reports do |t|
      t.references :device, null: false, foreign_key: true
      t.string :period
      t.text :data
      t.datetime :generated_at

      t.timestamps
    end
  end
end
