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

  def makeJSONMessage
    iphone_notification = {
      soulObject: self
    }

    return iphone_notification
  end

  def broadcast(devices)
    #send sns message to all subscribers in the topic

    jsonMessage = self.to_json
    alertMessage = "Incoming Soul"
    jsonObject = @soul

    devices.each do |currentDevice|
      deviceToken = currentDevice.token
      execString = 'node app.js ' + alertMessage.shellescape + " " + jsonObject.to_json + " " + deviceToken
      begin
        exec execString
      rescue
        puts "rescued!"
      end

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
