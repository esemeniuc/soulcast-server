//example command
//exec 'node app.js "alertMessage" "{\"id\":123}"'
//bash
//node app.js "alertMessage" "{\"id\":123}"
var badgeCount = 9
var alertMessage = "Incoming Soul"
var payloadJSON = {}
// Enter the device token from the Xcode console
var deviceToken = "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"
// console.log("before foreach " + deviceToken)

process.argv.forEach(function (val, index, array) {
    console.log(index + ': ' + val);
    if (index == 2) {
        alertMessage = val
    } else if (index == 3) {
        payloadJSON = JSON.parse(val)
    } else if (index == 4) {
        deviceToken = val
    }
});

// console.log("after " + deviceToken)
//
// console.log(alertMessage)
// console.log(payloadJSON)



var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({
    token: {
        key: 'apns.p8', // Path to the key p8 file
        keyId: 'VK2F43FXVB', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: '59SVXWFZ98' // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: false // Set to true if sending a notification to a production iOS app
});


// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'ml.soulcast.app';

// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// Set app badge indicator
notification.badge = badgeCount;

// Play ping.aiff sound when the notification is received
notification.sound = 'ping.aiff';

// Display the following message (the actual notification text, supports emoji)
notification.alert = alertMessage;

// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
notification.payload = payloadJSON;

// Actually send the notification
apnProvider.send(notification, deviceToken).then( (result) => {
    // Check the result for any failed devices
    console.log(result);
    // console.error("something")
    process.exit()
});


