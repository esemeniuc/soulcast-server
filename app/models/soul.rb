class Soul < ApplicationRecord
  belongs_to :device
  before_save :sendToOthers

  def createSNSTopic
    #make a new SNS topic and returns the topic
    snsResource = Aws::SNS::Resource.new
    topic = snsResource.create_topic(name: Time.now.to_i.to_s) #make topic based on current time
    puts "topic arn is: " + topic.arn
    @snsTopic = topic
    return topic
  end

  def reaches(device)
    #check if this soul reaches another device
    radiusBounds = [self.radius, device.radius].min
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    if distance < radiusBounds
      return true
    end
    return false
  end

  def devicesWithinMutualRange #returns recent devices in the mutual radius
    devicesInRange = []

    self.device.otherRecentDevices.each do |device|
      if reaches(device)
        devicesInRange.append(device)
      end
    end

    return devicesInRange
  end

  def subscribe(devicesInRange)
    subscriptionARNArray = []

    devicesInRange.each do |device|
      subscriptionARN = device.subscribeToTopic(@snsTopic)
      subscriptionARNArray.push(subscriptionARN)
    end
    return subscriptionARNArray
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
    #send sns message to all subscribers in the topic
    snsMessage = self.makeSNSMessage
    @snsTopic.publish({message: snsMessage.to_json, message_structure: "json"})
  end

  def cleanUp(subscriptionARNArray)
    #clean up unneeded topic and subscriptions
    @snsTopic.delete

    subscriptionARNArray.each do |subscription|
      subscription.delete
    end
  end

  def notify(devices)
    #expects an array parameter
    createSNSTopic
    subscriptionARNArray = subscribe(devices) #store arns for cleanup
    broadcast
    cleanUp(subscriptionARNArray)
  end

  def sendToOrigin #send back to june for testing
    notify([device])
  end

  def sendToOthers #send back to june for testing
    notify(devicesWithinMutualRange)
  end


  before_save do
    deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
      puts deviceCount.to_s + " devices within range--------------------------------"
    end
  end
end
