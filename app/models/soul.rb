class Soul < ApplicationRecord
  belongs_to :device
  has_many :histories, dependent: :destroy
  # has_one :history, through: :device
  before_validation :get_device
  validates :s3Key, :epoch, :latitude, :longitude, :radius, :device_id, presence: true
  validates_length_of :epoch, maximum: 10
  after_save :updateDeviceLocation, :sendToOthers, :status_output

  def get_device
    if self.device_id # associate a device to our soul, not a hack
      self.device = Device.find(self.device_id)
    end
  end

  def updateDeviceLocation
    self.device.update(latitude: self.latitude, longitude: self.longitude, radius: self.radius)
  end

  def broadcastIos(iosDevices)
    execString = generateJSONString(iosDevices)
    if execString != nil # no devices to send to
      system execString
    end
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
    end

    return nil
  end

  def soulRouter(devices)
    iosRecipients = devices.select do |currentDevice|
      Device.oses[currentDevice.os] == Device.oses[:ios]
    end

    androidRecipients = devices.select do |currentDevice|
      Device.oses[currentDevice.os] == Device.oses[:android]
    end
    return Hash(ios: iosRecipients, android: androidRecipients)
  end


  def broadcastAndroid(androidDevices)
    payload = {data: {soulObject: self}}
    recipients = androidDevices.map do |elem|
      elem.token
    end

    if Device.oses[self.device.os] == Device.oses[:android]

      recipients.append(self.device.token)
    end

    FirebaseHelper.androidFCMPush(recipients, payload)
  end

  def broadcast(devices)
    # test from rails console with Soul.last.sendToOthers
    routedSouls = soulRouter(devices)
    broadcastIos(routedSouls[:ios])
    broadcastAndroid(routedSouls[:android])
    make_history(devices) #save the history of who we sent to
  end

  def make_history(devices)# generates the history upon saving a soul
    History.make_history(self, devices)
  end

  def sendToEveryone #send to all users
    broadcast(Device.all.to_ary) #send to everything
  end

  def sendToOrigin #send back to person who tried to send out
    broadcast([device])
  end

  def sendToOthers #send to other users
    broadcast(self.device.broadcastableDevices) #devices within mutual range and not blocked
  end

  def status_output
    deviceInRangeCount = self.device.devicesWithinMutualRange.count
    if deviceInRangeCount > 0
      puts 'Devices within range (incl blocked): ' + deviceInRangeCount.to_s
    end
  end

end
