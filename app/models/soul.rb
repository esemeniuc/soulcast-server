class Soul < ApplicationRecord
  belongs_to :device

  def createSNSTopic
    #make a new SNS topic and returns the topic
    snsResource = Aws::SNS::Resource.new
    topic = snsResource.create_topic(name: Time.now.to_i.to_s) #make topic based on current time
    puts "topic arn is: " + topic.arn
    @snsTopic = topic
    return topicb
  end

  def devicesWithinMutualRange
	#temporarily returns all devices with unique arns from the devices table
    return Device.all.to_ary #returns all
  end

  def subscribeDevicesInRange
    devicesInRange = self.devicesWithinMutualRange

    @subscriptionARNArray = [] #store the arns in an array so we can clear the subscriptions later-
    devicesInRange.each do |device|
      subscriptionARN = device.subscribeToTopic(@snsTopic)
      @subscriptionARNArray.push(subscriptionARN)
      puts subscriptionARN
    end

  end

  def makeSNSMessage
    iphone_notification = {
      aps: { alert: "Incoming Soul", sound: "default", badge: 1 },
      soulObject: self
    }

    snsMessage = {
      default: "This is the default message which must be present when publishing a message to a topic. The default message will only be used if a message is not present for one of the notification platforms.",
      APNS_SANDBOX: iphone_notification.to_json,
      APNS: iphone_notification.to_json
    }

    return snsMessage
  end

  def broadcast
    #send sns message to all subscibers in the topic
    snsMessage = self.makeSNSMessage
    @snsTopic.publish({message: snsMessage.to_json, message_structure: "json"})
  end

  def cleanUp
    #clean up unneeded topic and subscriptions
    @snsTopic.delete

    @subscriptionARNArray.each do |subscription|
      subscription.delete
    end
  end

  def goldenPath
    #reset the db first
    #rails db:reset
    Device.first.delete
    testDevice = Device.create(token: "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6")
    testDevice.register

    testSoul = Soul.create(soulType: "testSoulType1", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 1, token: "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6", device_id: 3)

    testSoul.createSNSTopic
    testSoul.subscribeDevicesInRange
    testSoul.broadcast

    testSoul.cleanUp
  end

  def sendToDevices
    #sends a soul to all devices in range
    testSoul.createSNSTopic
    testSoul.subscribeDevicesInRange
    testSoul.broadcast
    testSoul.cleanUp
  end

  before_save do
    deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
      puts deviceCount.to_s + " devices within range--------------------------------"
      #sendToDevices
    end
  end
end
