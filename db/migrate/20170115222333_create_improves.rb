class CreateImproves < ActiveRecord::Migration[5.0]
  def change
    create_table :improves do |t|
      t.string :soulType
      t.string :s3Key
      t.integer :epoch
      t.float :latitude
      t.float :longitude
      t.float :radius
      t.string :token
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
