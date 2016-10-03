class Device < ApplicationRecord
  has_many :souls
  #after_create :register
  validates :token, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :radius, presence: true

  def simulator
    if self.token == nil #for simulator, add june's token if we have none
      self.token = "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6" #temp hack, beware
    end
  end

  def register
    #create platform endpoint (take in iPhone token, and generate an Endpoint ARN)
    #under the application (eg arn:aws:sns:us-west-2:692812027053:app/APNS_SANDBOX/restappPA
    #for Apple iOS Dev)
    #docs: http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html#create_platform_endpoint-instance_method
    platformARN = "arn:aws:sns:us-west-2:692812027053:app/APNS_SANDBOX/restappPA"
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
