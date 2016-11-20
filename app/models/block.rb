class Block < ApplicationRecord
  belongs_to :device
  validates :token, presence: true
  validates :blockedToken, presence: true
  validates :token, uniqueness: {scope: :blockedToken}
end
