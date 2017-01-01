class Device < ApplicationRecord
  has_many :souls
  # has_many :blocks
  has_many :histories
  # has_one :history
  validates :token, :latitude, :longitude, :radius, presence: true
  validates :token, uniqueness: true

  def self.allRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).order(:updated_at) #all devices updated in the last week
  end

  def otherRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).where.not(id: self.id).order(:updated_at) #all devices except the caller updated in the last week
  end

  def blocked?(input_device)
    return Block.where(blocker_id: self.id, blockee_id: input_device.id).exists?
  end

  def not_blocked?(input_device)
    return !blocked?(input_device)
  end

  def reaches?(device) # check if this device reaches another device
    # debug print
    # puts 'Self radius: ' + self.radius.to_s + "\tDevice radius: " + device.radius.to_s

    minRadius = [self.radius, device.radius].min
    radiusInKM = minRadius * 111.2 #conversion factor for degrees latitude to km
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    return (distance < radiusInKM)
  end

  def devicesWithinMutualRangeAndNotBlocked # returns an array of all devices that are in the mutual radius and not blocked
    allDevices = devicesWithinMutualRange
    broadcaster_id = self.id # this is an int
    devicesToRemove = Device.where(id: Block.where(blockee_id: broadcaster_id).pluck(:blockee_id)) #inner query gets all ids that blocked the broadcaster
    result = allDevices - devicesToRemove

    puts "All other devices within mutual range: " + allDevices.count.to_s + ", All non blocked: " + result.count.to_s
    return result
  end

  def devicesWithinMutualRange # returns an array of recent devices in the mutual radius
    devicesInRange = []

    otherRecentDevices.each do |device| # FIXME to use soul radius, currently using device-device radius
      if reaches?(device)
        devicesInRange.append(device)
      end
    end

    return devicesInRange
  end

  def nearbyDeviceCount #returns the number of non blocked nearby device updated in the last week
    return devicesWithinMutualRangeAndNotBlocked.count
  end

end
