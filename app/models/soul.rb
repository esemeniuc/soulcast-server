class Soul < ApplicationRecord
  belongs_to :device
  before_save :sendToOthers

  def reaches(device)
    #check if this soul reaches another device
    radiusBounds = [self.radius, device.radius].min
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    if distance < radiusBounds
      return true
    end
    return false
  end

  def devicesWithinMutualRange #returns recent devices in the mutual radius
    devicesInRange = []

    self.device.otherRecentDevices.each do |device|
      if reaches(device)
        devicesInRange.append(device)
      end
    end

    return devicesInRange
  end

  def broadcast(devices)

    alertMessage = 'Incoming Soul'
    jsonObject = self.to_json

    devices.each do |currentDevice|
      deviceToken = currentDevice.token
      execString = 'node app.js ' + alertMessage.shellescape + ' ' + jsonObject + ' ' + deviceToken
      system execString
    end
  end

  def sendToOrigin #send back to person who tried to send out -- testing
    broadcast([device])
  end

  def sendToOthers #send to other users
    broadcast(devicesWithinMutualRange)
  end

  before_save do
    deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
      puts deviceCount.to_s + ' devices within range--------------------------------'
    end
  end
end
