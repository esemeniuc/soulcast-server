class Block < ApplicationRecord
  # belongs_to :device
  validates :blocker_id, presence: true
  validates :blockee_id, presence: true
  validates :blocker_id, uniqueness: {scope: :blockee_id}
  before_validation :make_relations, unless: :relations_set?
  after_save :remove_blocked_history

  def relations_set?
    if blocker_id == nil || blockee_id == nil
      return false
    end

    return true
  end

  def make_relations
    self.blocker_id = Device.find_by_token!(self.blocker_token).id
    self.blockee_id = Device.find_by_token!(self.blockee_token).id
    puts "blocker_id = " + self.blocker_id.to_s + ", blockee_id = " + self.blockee_id.to_s
  end

  def remove_blocked_history
    soul_id_of_histories_to_delete = Soul.where(device_id: blockee_id).pluck(:id)
    historiesToDelete = History.where(soul_id: soul_id_of_histories_to_delete, device_id: blocker_id)
    historiesToDelete.destroy_all

    soul_id_of_histories_to_delete = Soul.where(device_id: blocker_id).pluck(:id)
    historiesToDelete = History.where(soul_id: soul_id_of_histories_to_delete, device_id: blockee_id)
    historiesToDelete.destroy_all
  end
end