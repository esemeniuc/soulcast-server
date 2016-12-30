class Block < ApplicationRecord
  # belongs_to :device
  validates :blocker_id, :blockee_id, presence: true
  validates :blocker_id, uniqueness: {scope: :blockee_id}
  before_validation :make_relations, unless: :relations_set?

  def relations_set?
    if blocker_id == nil || blockee_id == nil
      return false
    end

    return true
  end

  def make_relations
    puts ("******************************************************")
    # binding.pry
    self.blocker_id = Device.find_by_token!(self.blocker_token).id
    self.blockee_id = Device.find_by_token!(self.blockee_token).id
    puts "blocker_id = " + self.blocker_id.to_s + "blockee_id = " + self.blockee_id.to_s
    puts ("-----------------------------------------------------")
  end

end