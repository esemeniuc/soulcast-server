class Device < ApplicationRecord
  has_many :souls
  has_many :blocks
  has_many :histories
  # has_one :history
  validates :token, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :radius, presence: true

  def self.allRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).order(:updated_at) #all devices updated in the last week
  end

  def otherRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).where.not(id: self.id).order(:updated_at) #all devices except the caller updated in the last week
  end

  def reaches(device) # check if this device reaches another device
    # debug print
    puts 'Self radius: ' + self.radius.to_s + "\tDevice radius: " + device.radius.to_s

    minRadius = [self.radius, device.radius].min
    radiusInKM = minRadius * 111.2 #conversion factor for degrees latitude to km
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    return (distance < radiusInKM)
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
