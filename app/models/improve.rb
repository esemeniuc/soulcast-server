class Improve < ApplicationRecord
  belongs_to :device
  before_validation :get_device

end


def get_device
  if self.device == nil # associate a device to our soul, not a hack
    self.device = Device.find_by_token(self.token)
  end
end