class CreateDailyVendorOrderDurationAggs < ActiveRecord::Migration
  def change
    create_table :daily_vendor_order_duration_aggs do |t|
      t.float :lat
      t.float :lng
      t.string :zip_code
      t.integer :warehouse
      t.integer :dispatched
      t.integer :distribution
      t.integer :out_for_delivery
      t.references :vendor, index: true, foreign_key: true
      t.date :date

      t.timestamps null: false
    end
    add_index :daily_vendor_order_duration_aggs, :lat
    add_index :daily_vendor_order_duration_aggs, :lng
    add_index :daily_vendor_order_duration_aggs, :zip_code
    add_index :daily_vendor_order_duration_aggs, :warehouse
    add_index :daily_vendor_order_duration_aggs, :dispatched
    add_index :daily_vendor_order_duration_aggs, :distribution
    add_index :daily_vendor_order_duration_aggs, :out_for_delivery
  end
end
