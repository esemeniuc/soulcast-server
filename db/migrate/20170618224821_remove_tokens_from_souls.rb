class RemoveTokensFromSouls < ActiveRecord::Migration[5.0]
  def change
    remove_column :souls, :token
  end
end
