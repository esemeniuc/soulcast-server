class CreateWaves < ActiveRecord::Migration[5.0]
  def change
    create_table :waves do |t|
      t.text :castVoice
      t.text :callVoice
      t.text :replyVoice
      t.string :casterToken
      t.string :callerToken
      t.string :type
      t.integer :epoch

      t.timestamps
    end
  end
end
