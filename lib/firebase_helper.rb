require 'rpush'

module FireBaseHelper

    # @@fcm = FCM.new('AIzaSyClgHCghxvRtwrKjjH9WD_y6obEs4euIGQ')

    # # registration_ids= ["12", "13"] # an array of one or more client registration tokens
    # # options = {data: {score: "123"}, collapse_key: "updated_score"}
    # # response = fcm.send(registration_ids, options)
    # # input, is array of ids, and the json data
    # def sendNotificationFCM(reg_ids, data)
    #   response = @@fcm.send(reg_ids, data)
    #   return response
    # end

    # module_function :sendNotificationFCM

    app = Rpush::Gcm::App.new
    app.name = "soulcast android"
    app.auth_key = "AIzaSyClgHCghxvRtwrKjjH9WD_y6obEs4euIGQ"
    app.connections = 1
    app.save!

    @@rpush = Rpush::Gcm::Notification.new
    @@rpush.app = Rpush::Gcm::App.find_by_name("soulcast android")

    def sendNotificationsVIArpush(reg_ids, data)
        @@rpush.registration_ids = reg_ids
        @@rpush.data = data
        @@rush.priority = 'normal'
        @@rpush.save!
    end

    module_function :sendNotificationsVIArpush

end