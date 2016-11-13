class Soul < ApplicationRecord
  belongs_to :device
  before_save :sendToOthers #check for making this work better

  def reaches(device) # returns true if this soul reaches another device
    mutualDistance = [self.radius, device.radius].min
    calculatedDistance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    if calculatedDistance < mutualDistance # check if we're within bounds
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

  def broadcast(devices) # test from rails console with Soul.last.sendToOthers
    alertMessage = 'Incoming Soul'
    jsonObject = {'soulObject': self}.to_json

    # turns all device tokens into a string that is space sperated
    tokenArray = [] # placeholder for all tokens only
    devices.each do |currentDevice|
      tokenArray.append(currentDevice.token)
    end
    devicesString = tokenArray.join(' ')

    execString = 'node app.js ' + alertMessage.shellescape + ' ' + jsonObject.shellescape + ' ' + devicesString.shellescape
    system execString

  end

  def sendToEveryone #send to all users
    broadcast(Device.all.to_ary) #send to everything
  end

  def sendToOrigin #send back to person who tried to send out
    broadcast([device])
  end

  def sendToOthers #send to other users
    broadcast(devicesWithinMutualRange)
  end

  def simulator
    if self.token == ENV.fetch('simulatorToken') # for simulator, set our token to be june's token if we have have
      self.sendToEveryone
    end
  end

  before_save do
    deviceInRangeCount = devicesWithinMutualRange.count
    if deviceInRangeCount > 0
      puts 'Devices within range: ' + deviceInRangeCount.to_s
    end
  end
end
