class Wave
  include ActiveModel::Model
  validates_presence_of :castVoice, :casterToken, :callerToken, :type, :epoch
  validates_length_of :epoch, maximum: 10

  attr_accessor :attributes
  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end


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


  def self.generateioswave(iosToken, wave)
    alertMessage = 'Incoming Wave'
    jsonObject = {'wave': wave}.to_json

    execString = 'node app.js ' + alertMessage.shellescape + ' ' + jsonObject.shellescape + ' ' + iosToken.shellescape
    return execString
  end

  def self.generateandroidWave(androidToken, wave)
    recipients = [androidToken]
    payload = {data: {'wave': wave}.to_json}
    FirebaseHelper.androidFCMPush(recipients, payload)
  end

  def self.echoBackWave(wave={})
    if wave[:type].eql? "call"
      deviceOs = getDeviceOs(wave[:callerToken])
      if deviceOs.eql? "ios"
        execString = generateJSONString(wave[:callerToken], wave)
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateandroidWave(wave[:callerToken], wave)
      end

    elsif wave[:type].eql? "reply"

      deviceOs = getDeviceOs(wave[:casterToken])
      if deviceOs.eql? "ios"
        execString = generateioswave(wave[:casterToken], wave)
        if execString != nil # no devices to send to
          system execString
        end
      elsif deviceOs.eql? "android"
        generateandroidWave(wave[:callerToken], wave)
      end
    end
  end

end
