class Soul < ApplicationRecord
  belongs_to :device

  def devicesWithinMutualRange
	#temporarily returns all devices with unique arns from the devices table
    return Device.all.to_ary #returns all
  end

  def sendToDevices(inputDeviceArray) #use self so we can call function from controller
    # params: an array of devices
    # TODO: make SNS topic
    # then subscribe devices to the topic
    # post the soul (an instance of self) to the topic
    # assert delivery confirmation from SNS
    # destroy topic

    require 'aws-sdk'

    sns = Aws::SNS::Client.new

    iphone_notification = {
        aps: { alert: "Hi2", sound: "default", badge: 1 },
        soulObject: self #add some shit here for soul object
    }

    sns_message = {
        default: "Hi there3",
        APNS_SANDBOX: iphone_notification.to_json,
        APNS: iphone_notification.to_json
    }

    #send message to each device
    inputDeviceArray.each do |device|
      snsResult = sns.publish(
        target_arn: device.arn,
        message: sns_message.to_json,
        message_structure: "json")

      puts "sent to endpoint arn: " + device.arn
    end


    puts "sent to device-----------------------------------------"
  end


  before_save do
	  deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
		puts deviceCount.to_s + " devices within range--------------------------------"
		sendToDevices(devicesWithinMutualRange)
    end
  end
end
