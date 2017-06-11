class Wave
  include ActiveModel::Model
  validates_presence_of :castVoice, :casterToken, :callerToken, :type, :epoch
  validates_length_of :epoch, maximum: 10
  # after_validation :echoBackWave

  attr_accessor :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

# ask if these should be class level methods
  def getDeviceOs(token)
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


  def generateiosWave(iosToken)
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

  def generateWave(token, os)
    if os.eql? "ios"
      return generateiosWave(token)
    elsif os.eql? "android"
      return generateandroidWave(token)
    end

  end

  def echoBackWave
    wave = self
    if wave.attributes[:type].eql? "call"
      deviceOs = getDeviceOs(wave.attributes[:callerToken])
      if deviceOs.eql? "ios"
        execString = generateWave(wave.attributes[:callerToken], deviceOs)
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateWave(wave.attributes[:callerToken], deviceOs)
      end

    elsif wave.attributes[:type].eql? "reply"

      deviceOs = getDeviceOs(wave.attributes[:casterToken])
      if deviceOs.eql? "ios"
        execString = generateWave(wave.attributes[:callerToken], deviceOs)
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateWave(wave.attributes[:callerToken], deviceOs)
      end
    end
    puts "Wave succesfully created and echoed"
  end

end
