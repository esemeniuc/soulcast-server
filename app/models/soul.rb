class Soul < ApplicationRecord
  belongs_to :device
  has_many :histories
  validates :s3Key, :epoch, :latitude, :longitude, :radius, :token, presence: true
  after_save :sendToOthers, :status_output

  def reaches(device) # returns true if this soul reaches another device
    mutualDistance = [self.radius, device.radius].min
    calculatedDistance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    puts "calculated distance = " + calculatedDistance.to_s
    if calculatedDistance < mutualDistance # check if we're within bounds
      return true
    end
    return false
  end

  def devicesWithinMutualRangeAndNotBlocked # returns an array of all devices that are in the mutual radius and not blocked
    allDevices = devicesWithinMutualRange
    puts "********************" + allDevices.size.to_s
    broadcaster = self.token # this is a string
    devicesToRemove = Device.joins(:blocks).where(blocks: {blockedToken: broadcaster}).to_a # array of tokens of people who dont want to hear broadcaster

    result = allDevices - devicesToRemove
    return result
  end

  def devicesWithinMutualRange # returns an array of recent devices in the mutual radius
    devicesInRange = []

    self.device.otherRecentDevices.each do |device| # FIXME to use soul radius, currently using device-device radius
      if reaches(device)
        devicesInRange.append(device)
      end
    end

    return devicesInRange
  end

  def generateJSONString(devices)
    if devices.length > 0
      alertMessage = 'Incoming Soul'
      jsonObject = {'soulObject': self}.to_json

      # turns all device tokens into a string that is space separated
      tokenArray = [] # placeholder for all tokens only
      devices.each do |currentDevice|
        tokenArray.append(currentDevice.token)
      end
      devicesString = tokenArray.join(' ')

      # final nodejs string
      execString = 'node app.js ' + alertMessage.shellescape + ' ' + jsonObject.shellescape + ' ' + devicesString.shellescape
      return execString
    else
      return nil
    end
  end

  def broadcast(devices)
    # test from rails console with Soul.last.sendToOthers
    execString = generateJSONString(devices)
    if execString != nil #no devices to send to
      system execString
      make_history(devices) #save the history of who we sent to
    end
  end

  def sendToEveryone #send to all users
    broadcast(Device.all.to_ary) #send to everything
  end

  def sendToOrigin #send back to person who tried to send out
    broadcast([device])
  end

  def sendToOthers #send to other users
    broadcast(devicesWithinMutualRangeAndNotBlocked)
  end

  def simulator
    if self.token == ENV.fetch('simulatorToken') # for simulator, set our token to be june's token if we have have
      self.sendToEveryone
    end
  end

  def status_output
    deviceInRangeCount = devicesWithinMutualRange.count
    if deviceInRangeCount > 0
      puts 'Devices within range (incl blocked): ' + deviceInRangeCount.to_s
    end
  end

  def make_history(devices)# generates the history upon saving a soul
    History.make_history(self, devices)
  end

end
