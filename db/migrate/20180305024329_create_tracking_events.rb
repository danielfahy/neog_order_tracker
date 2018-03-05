class CreateTrackingEvents < ActiveRecord::Migration
  def change
    create_table :tracking_events do |t|
      t.time :created_at
      t.string :tracking_id
      t.integer :status, default: 0
      t.references :vendor, index: true, foreign_key: true
      t.string :zip_code
      t.integer :duration

      t.timestamps null: false
    end
    add_index :tracking_events, :created_at
    add_index :tracking_events, :tracking_id
    add_index :tracking_events, :status
    add_index :tracking_events, :zip_code
  end
end
