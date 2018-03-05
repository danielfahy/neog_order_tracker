class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip_code
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
    add_index :addresses, :state
    add_index :addresses, :zip_code
    add_index :addresses, :lat
    add_index :addresses, :lng
  end
end
