require 'fcm'

module FireBaseHelper

    @@fcm = FCM.new(ENV['FCMKEY'])

    def androidFCMPush(recipients, payload)
        response = @@fcm.send(recipients, payload)
        return response
    end

    module_function :androidFCMPush

end