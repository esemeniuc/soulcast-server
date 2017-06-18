class Block < ApplicationRecord
  # belongs_to :device
  validates :blocker_id, presence: true
  validates :blockee_id, presence: true
  validates :blocker_id, uniqueness: {scope: :blockee_id}
  after_save :remove_blocked_history

  def remove_blocked_history
    soul_id_of_histories_to_delete = Soul.where(device_id: blockee_id).pluck(:id)
    historiesToDelete = History.where(soul_id: soul_id_of_histories_to_delete, device_id: blocker_id)
    historiesToDelete.destroy_all

    soul_id_of_histories_to_delete = Soul.where(device_id: blocker_id).pluck(:id)
    historiesToDelete = History.where(soul_id: soul_id_of_histories_to_delete, device_id: blockee_id)
    historiesToDelete.destroy_all
  end
end