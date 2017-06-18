//purpose: send messages via APNS
//Examples:

//Command from ruby:
//system 'node app.js "alertMessage" "{\"id\":123}" "aad30922df1f4ebe9a393e6cc8671b67543c5fbbea53da10789c1b7b347aa6cb 5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104"'

//Command from bash
//node app.js "Incoming Soul" '{"soulObject":{"id":null,"soulType":null,"s3Key":"1478379996","epoch":1478379996,"longitude":-122.91424100294,"latitude":49.27776454089607,"radius":0.01559111972229993,"token":"aad30922df1f4ebe9a393e6cc8671b67543c5fbbea53da10789c1b7b347aa6cb","device_id":3,"created_at":null,"updated_at":null}}' "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104 aad30922df1f4ebe9a393e6cc8671b67543c5fbbea53da10789c1b7b347aa6cb"

"use strict"; //strict mode

//call should have 5 parameters.
//0 executable name (nodejs)
//1 js file to execute with nodejs
//2 notification message that user sees
var alertMessage = process.argv[2];
//3 soulobject in json
var payloadJSON = JSON.parse(process.argv[3]);
//4 tokens string to send to
var deviceTokens = process.argv[4].split(" "); //split on spaces

//print out what was executed
// for(var i = 0; i < process.argv.length; i++)
// {
//     console.log(i + ': ' + process.argv[i]);
// }

//get dev or production mode (true is production, false is dev mode)
require('dotenv').config();
var jsEnv = process.env['JS_ENV'];
var envMode = true; //assume production mode by default
if(jsEnv == 'development')
{
    envMode = false;
}

//enable assertions
const assert = require('assert');

//sanity check
assert(process.argv.length == 5, "Number of parameters do not match 5");
assert(process.argv[4].length == (64 * deviceTokens.length) + (deviceTokens.length - 1), "Token length is incorrect"); //FIXME: try with 1 token only

assert(typeof payloadJSON.soulObject === 'object');
assert(typeof payloadJSON.soulObject.s3Key === 'string');
assert(typeof payloadJSON.soulObject.longitude === 'number');
assert(typeof payloadJSON.soulObject.latitude === 'number');
assert(typeof payloadJSON.soulObject.radius === 'number');
// assert(typeof payloadJSON.soulObject.token === 'string');
assert(typeof payloadJSON.soulObject.device_id === 'number');

//start apns stuff
var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({
    token: {
        key: 'apns.p8', // Path to the key p8 file
        keyId: 'VK2F43FXVB', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: '59SVXWFZ98' // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: jsEnv // Set to true if sending a notification to a production iOS app
});


// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'ml.soulcast.app';

// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// Set app badge indicator
notification.badge = 1;

// Play ping.aiff sound when the notification is received
notification.sound = 'ping.aiff';

// Display the following message (the actual notification text, supports emoji)
notification.alert = alertMessage;

// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
notification.payload = payloadJSON;

// Actually send the notification
apnProvider.send(notification, deviceTokens).then(function(result)
{
    // Check the result for any failed devices
    console.log(result);
    process.exit(result.sent.length); //return how many devices were successfully sent to
});

// For one-shot notification tasks you may wish to shutdown the connection
// after everything is sent, but only call shutdown if you need your
// application to terminate.
// apnProvider.shutdown();
