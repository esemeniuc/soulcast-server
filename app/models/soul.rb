class Soul < ApplicationRecord
  belongs_to :device
  before_validation :addfakeARN

  def addfakeARN
      self.device_id = 1
      puts ("added fake arn-----------------------------------")
  end

  def withinMutualRange
    #checks if the souls devices are within a mutually overlapping range
    puts "within range----------------------------------------"
    return true
  end

  def devicesWithinMutualRange
    return [self.device.arn]
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

      puts "endpoint arn is " + device.arn
    end


    puts "sent to device-----------------------------------------"
  end


  before_save do
    if (withinMutualRange)
      puts("we got called-------------------------------------")
      #sendToDevices(Device.all)
    end
  end
end
