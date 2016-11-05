class Device < ApplicationRecord
  has_many :souls
  validates :token, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :radius, presence: true

  def self.allRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).order(:updated_at) #all devices accessed in the last week
  end

  def otherRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).where.not(id: self.id).order(:updated_at) #only scan against device accessed in the last week
  end

  def reaches(device)
    #check if this device reaches another device
    puts self.radius
    puts "-----------"
    puts device.radius
    radiusBounds = [self.radius, device.radius].min
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    if distance < radiusBounds
      return true
    end
    return false
  end

  def nearbyDeviceCount #returns the number of nearby device updated in the last week
    nearbyDevices = 0
    otherRecentDevices.each do |device|
      if reaches(device)
        nearbyDevices += 1
      end
    end

    return nearbyDevices
  end

end
