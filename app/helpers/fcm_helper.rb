require 'fcm'

module FcmHelper

	fcm = FCM.new("my_api_key")

	# registration_ids= ["12", "13"] # an array of one or more client registration tokens
	# options = {data: {score: "123"}, collapse_key: "updated_score"}
	# response = fcm.send(registration_ids, options)
	# input, is array of ids, and the json data
	def sendNotificationFCM(reg_ids, data)
		response = fcm.send(reg_ids, data)
		return response
	end

end