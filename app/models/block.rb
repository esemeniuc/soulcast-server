class Block < ApplicationRecord
  belongs_to :device
  validates :token, presence: true
  validates :blockedToken, presence: true
  validates :token, uniqueness: {scope: :blockedToken}
  before_create :find_tokens

  def find_tokens
    self.device = Device.find_by_token!(self.token)
    self.blocked_device_id = Device.find_by_token!(self.blockedToken).id
  end

end
