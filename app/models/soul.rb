class Soul < ApplicationRecord
  belongs_to :device

  def devicesWithinMutualRange
	#temporarily returns all devices with unique arns from the devices table
    return Device.all.to_ary #returns all
  end

  def createSNSTopic
    #make a new SNS topic
    require 'aws-sdk'
    sns = Aws::SNS::Resource.new
    topic = sns.create_topic(name: Time.now.to_i.to_s) #make topic based on current time
    puts topic.arn
    return topic
  end

  def subscribeDevicesToTopic(inputDeviceArray, inputTopic)
    #subscribes devices from inputDeviceArray to inputTopic
    return true
  end

  def makeSNSMessage
    iphone_notification = {
      aps: { alert: "Hi2", sound: "default", badge: 1 },
      soulObject: self
    }

    sns_message = {
      default: "Hi there3",
      APNS_SANDBOX: iphone_notification.to_json,
      APNS: iphone_notification.to_json
    }

    return sns_message
  end

  def sendToDevices(inputDeviceArray) #use self so we can call function from controller

    #topic = createSNSTopic #make new topic
    #subscribeResult = DevicesToTopic(inputDeviceArray, inputTopic) #subscribe devices to the topic

    sns = Aws::SNS::Client.new

    sns_message = makeSNSMessage

    #send message to each device
    #TODO: convert so we post the soul (an instance of self) to the topic
    inputDeviceArray.each do |device|
      snsResult = sns.publish(
        target_arn: device.arn,
        message: sns_message.to_json,
        message_structure: "json")

    #   if(snsResult is bad)
    #     puts "error"
    #   end

      puts "sent to endpoint arn: " + device.arn
    end

    #topic.destroy #destroy the topic
  end

  before_save do
    deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
      puts deviceCount.to_s + " devices within range--------------------------------"
      sendToDevices(devicesWithinMutualRange)
    end
  end
end
