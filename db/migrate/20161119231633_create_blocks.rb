class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.string :token
      t.string :blockedToken
      t.references :device, foreign_key: true
      t.integer :blocked_device_id, foreign_key: true

      t.timestamps
    end
  end
end
