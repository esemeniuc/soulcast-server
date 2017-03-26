require 'rpush'

module FireBaseHelper

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

        rpushPush()
    end

    def rpushPush()
        Rpush.push
    end

    module_function :sendNotificationsVIArpush

end