
class Soul < ApplicationRecord
  include FireBaseHelper

  belongs_to :device
  has_many :histories, dependent: :destroy
  # has_one :history, through: :device
  before_validation :get_device
  validates :s3Key, :epoch, :latitude, :longitude, :radius, :token, :device_id, presence: true
  after_save :updateDeviceLocation, :sendToOthers, :status_output

  def get_device
    if self.device == nil # associate a device to our soul, not a hack
      self.device = Device.find_by_token(self.token)
    end
  end

  def updateDeviceLocation
    self.device.update(latitude: self.latitude, longitude: self.longitude, radius: self.radius)
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
      # puts execString
      return execString
    else
      return nil
    end
  end

  def generateAndroidbroadcast(devices)
    ## figure out devices that are android, filter

    ## get registration ids of devices
    ## build data package
    registrationID = []
    data = {'soulObject': self}.to_json
    devices.each do |currentDevice|
      if currentDevice.os == "android"
        registrationID.append(currentDevice.token)
      end
    end
    FireBaseHelper.sendNotificationsVIArpush(registrationID, data)

  end

  def broadcast(devices)
    # test from rails console with Soul.last.sendToOthers
    execString = generateJSONString(devices)
    if execString != nil # no devices to send to
      system execString
      make_history(devices) #save the history of who we sent to
    end
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
