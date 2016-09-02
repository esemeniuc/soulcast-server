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
  end
end
