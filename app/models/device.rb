class Device < ApplicationRecord
  has_many :souls

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
    self.save

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
