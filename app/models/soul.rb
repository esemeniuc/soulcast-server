class Soul < ApplicationRecord
  belongs_to :device
  before_save :echoToOthers

  def createSNSTopic
    #make a new SNS topic and returns the topic
    snsResource = Aws::SNS::Resource.new
    topic = snsResource.create_topic(name: Time.now.to_i.to_s) #make topic based on current time
    puts "topic arn is: " + topic.arn
    @snsTopic = topic
    return topic
  end

  def devicesWithinMutualRange
	#temporarily returns all devices with unique arns from the devices table
    # result = devices_within_radius.each do |each_device|
    #   reaches(each_device)
    # end
    return Device.all.to_ary
  end

  def reaches(device)
    deviceRadius = device.radius
    deviceLongitude = device.longitude
    deviceLatitude = device.latitude

    #give distance between soul and device
    Geocoder::Calculations.distance_between([latitude, longitude], [device.latitude, device.longitude])
    #Geocoder::Calculations.distance_between([49.25, -122.95], [48.8584, 2.294694])
    if condition

    end
  end

  def devices_within_radius
    rDelta = to_latitude_convert(radius)
    minLongitude =  longitude - rDelta
    maxLongitude = longitude + rDelta
    minLatitude =  latitude - rDelta
    maxLatitude =  latitude + rDelta
    squareAreaDevices = Device.where(longitude: minLongitude..maxLongitude, latitude: minLatitude..maxLatitude)
    puts(squareAreaDevices)
    squareAreaDevices
  end

  def to_latitude_convert(radius)
    return radius * 1 #TODO: some constant to convert radius to latitudeDelta
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
    #send sns message to all subscibers in the topic
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

  def echoToOrigin
    #send back to june for testing
    notify([device])
  end

  def echoToOthers
    #send back to june for testing
    notify(Device.all.where.not(id: device.id).to_ary)
  end

  def notify(devices)
    #expect an array parameter
    createSNSTopic
    subscriptionARNArray = subscribe(devices) #store arns for cleanup
    broadcast
    cleanUp(subscriptionARNArray)

  end

  before_save do
    deviceCount = devicesWithinMutualRange.count
    if deviceCount > 0
      puts deviceCount.to_s + " devices within range--------------------------------"
      #sendToDevices
    end
  end
end
