class Wave
  include ActiveModel::Model
  validates_presence_of :castVoice, :casterToken, :callerToken, :type, :epoch
  validates_length_of :epoch, maximum: 10
  after_validation :echoBackWave

  attr_accessor :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

# ask if these should be class level methods
  def self.getDeviceOs(token)
    if (token != nil)
      device = Device.find_by_token(token)
    end
    return device.os
  end

  def self.getDevicebyid(id)
    if (id != nil)
      device = Device.find_by_token(id)
    end
    return device
  end


  def generateioswave(iosToken)
    alertMessage = 'Incoming Wave'
    jsonObject = {'wave': self}.to_json

    execString = 'node app.js ' + alertMessage.shellescape + ' ' + jsonObject.shellescape + ' ' + iosToken.shellescape
    return execString
  end

  def generateandroidWave(androidToken)
    recipients = [androidToken]
    payload = {data: {'wave': self}.to_json}
    FirebaseHelper.androidFCMPush(recipients, payload)
  end

  def echoBackWave
    wave = self
    if wave[:type].eql? "call"
      deviceOs = getDeviceOs(wave[:callerToken])
      if deviceOs.eql? "ios"
        execString = generateioswave(wave[:callerToken])
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateandroidWave(wave[:callerToken])
      end

    elsif wave[:type].eql? "reply"

      deviceOs = getDeviceOs(wave[:casterToken])
      if deviceOs.eql? "ios"
        execString = generateioswave(wave[:casterToken])
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateandroidWave(wave[:callerToken])
      end
    end
  end

end
