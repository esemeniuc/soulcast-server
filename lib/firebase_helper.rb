require 'fcm'

module FireBaseHelper

    @@fcm = FCM.new("api key")

    def sendNotificationsFCM(reg_ids, data)
        response = @@fcm.send(reg_ids, data)
        return response
    end

    module_function :sendNotificationsFCM

end