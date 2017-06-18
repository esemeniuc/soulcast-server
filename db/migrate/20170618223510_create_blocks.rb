class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.int :blocker_id
      t.integer :blockee_id

      t.timestamps
    end
  end
end
