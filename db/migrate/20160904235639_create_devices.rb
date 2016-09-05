class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :token
      t.float :longitude
      t.float :latitude
      t.float :radius
      t.string :arn

      t.timestamps
    end
    add_index :devices, :token, unique: true
    add_index :devices, :arn, unique: true
  end
end
