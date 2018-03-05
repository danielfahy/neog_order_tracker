class CreateVendorOrderDurationAggregates < ActiveRecord::Migration
  def change
    create_table :vendor_order_duration_aggregates do |t|
      t.string :zip_code
      t.float :lat
      t.float :lng
      t.integer :warehouse
      t.integer :dispatched
      t.integer :distribution
      t.integer :out_for_delivery
      t.references :vendor, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :vendor_order_duration_aggregates, :zip_code
    add_index :vendor_order_duration_aggregates, :lat
    add_index :vendor_order_duration_aggregates, :lng
    add_index :vendor_order_duration_aggregates, :warehouse
    add_index :vendor_order_duration_aggregates, :dispatched
    add_index :vendor_order_duration_aggregates, :distribution
    add_index :vendor_order_duration_aggregates, :out_for_delivery
  end
end
