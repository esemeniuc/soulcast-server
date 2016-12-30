class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.string :blocker_token
      t.string :blockee_token
      t.integer :blocker_id
      t.integer :blockee_id

      t.timestamps
    end
      add_index :blocks, :blocker_id
      add_index :blocks, :blockee_id
      add_index :blocks, [:blocker_id, :blockee_id], unique: true
  end
end
