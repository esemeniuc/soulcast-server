class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :token
      t.float :latitude
      t.float :longitude
      t.float :radius
      t.string :os

      t.timestamps
    end
    add_index :devices, :token, unique: true
  end
end
