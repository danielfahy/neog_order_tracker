class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.string :tracking_id
      t.string :zip_code
      t.integer :total
      t.references :address, index: true, foreign_key: true
      t.references :vendor, index: true, foreign_key: true
      t.integer :status, default: 0
      t.integer :tracking_status, default: 0

      t.timestamps null: false
    end
    add_index :orders, :number
    add_index :orders, :tracking_id
    add_index :orders, :zip_code
  end
end
