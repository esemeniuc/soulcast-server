class Device < ApplicationRecord
  has_many :souls
  #after_create :register
  validates :token, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :radius, presence: true

  def simulator
    if self.token == nil #for simulator, add june's token if we have none
      self.token = Rails.application.secrets.juneToken #temp hack, beware
    end
  end

  def register
    #create platform endpoint (take in iPhone token, and generate an Endpoint ARN)
    #under the application (eg arn:aws:sns:us-west-2:692812027053:app/APNS_SANDBOX/restappPA
    #for Apple iOS Dev)
    #docs: http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html#create_platform_endpoint-instance_method
    platformARN = Rails.application.secrets.platformARN
    snsClient = Aws::SNS::Client.new
    endpointARN = snsClient.create_platform_endpoint({
      platform_application_arn: platformARN, # required
      token: self.token # required
      # custom_user_data: "String",
      # attributes: {
      #   "String" => "String",
      #   },
    })

    #update our database to have the new arn
    self.arn = endpointARN.endpoint_arn

    puts "endpoint arn is: " + self.arn
  end

  def self.allRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).order(:updated_at) #all devices accessed in the last week
  end

  def otherRecentDevices
    return Device.where('updated_at > ?', 1.week.ago).where.not(id: self.id).order(:updated_at) #only scan against device accessed in the last week
  end

  def reaches(device)
    #check if this device reaches another device
    puts self.radius
    puts "-----------"
    puts device.radius
    radiusBounds = [self.radius, device.radius].min
    distance = Geocoder::Calculations.distance_between([self.latitude, self.longitude], [device.latitude, device.longitude], :units => :km)
    if distance < radiusBounds
      return true
    end
    return false
  end

  def nearbyDeviceCount #returns the number of nearby device updated in the last week
    nearbyDevices = 0

   otherRecentDevices.each do |device|
      if reaches(device)
        nearbyDevices += 1
      end
    end

    return nearbyDevices
  end

  def subscribeToTopic(inputTopic)
    #create subscription for this device to inputTopic
    #doc: http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Topic.html#subscribe-instance_method

    subscription = inputTopic.subscribe({
      protocol: 'application',
      endpoint: self.arn
    })
    puts "subscription arn is: " + subscription.arn
    return subscription
  end

end
