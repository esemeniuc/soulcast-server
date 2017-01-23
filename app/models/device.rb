class Device < ApplicationRecord
  has_many :souls
  # has_many :blocks
  has_many :histories
  # has_one :history
  validates :token, :latitude, :longitude, :radius, presence: true
  validates :token, uniqueness: true

  def is_blocking?(input_device) #does this device block input_device?
    return Block.where(blocker_id: self.id, blockee_id: input_device.id).exists?
  end

  def is_blocked_by?(input_device) #is this device blocked by input_device?
    return Block.where(blocker_id: input_device.id, blockee_id: self.id).exists?
  end

  def blocked?(input_device)
    if self.is_blocking?(input_device) || self.is_blocked_by?(input_device)
      return true
    end

    return false
  end

  def not_blocked?(input_device)
    return !blocked?(input_device)
  end

  def in_mutual_radius?(device) # check if this device is in the mutual radius another device
    # debug print
    # puts 'Self radius: ' + self.radius.to_s + "\tDevice radius: " + device.radius.to_s

    minRadius = [self.radius, device.radius].min
    radiusInKM = minRadius * 111.2 #conversion factor for degrees latitude to km
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    return (distance < radiusInKM)
  end

  def reaches?(input_device) #check if a soul sent from this device can be transmitted to another device
    return in_mutual_radius?(input_device) && not_blocked?(input_device)
  end

  def self.allRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).order(:updated_at) #all devices updated in the last week
  end

  def otherRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).where.not(id: self.id).order(:updated_at) #all devices except the caller updated in the last week
  end

  def devicesWithinMutualRange # returns an array of recent devices in the mutual radius including blocked devices
    devicesInRange = []

    otherRecentDevices.each do |device|
      if in_mutual_radius?(device)
        devicesInRange.append(device)
      end
    end

    return devicesInRange
  end

  # returns an array of all devices in mutual radius that did not block the sender and the sender did no block
  def broadcastableDevices
    allDevices = devicesWithinMutualRange
    devicesBlockingSender = Block.where(blockee_id: self.id).pluck(:blocker_id)
    devicesBlockedBySender = Block.where(blocker_id: self.id).pluck(:blockee_id)
    deviceIDsToRemove = devicesBlockingSender | devicesBlockedBySender

    devicesToRemove = Device.where(id: deviceIDsToRemove) #inner query gets all ids that blocked the broadcaster
    result = allDevices - devicesToRemove

    puts allDevices.count.to_s + " other devices within mutual range, " + result.count.to_s + " other devices that are not blocked"
    return result
  end

  def nearbyDeviceCount #returns the number nearby devices non blocked updated in the last week
    return broadcastableDevices.count
  end

  def block (blockee)
    #make a new block object
    Block.create(blocker_id: self.id, blockee_id: blockee.id)
  end

end
