# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/0e01488f-6278-392f-a77b-acfe8902a6ac", token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", latitude: 49.2812277842772, longitude: -122.956075, radius: 10)
Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/32efd1e1-2db3-3882-b5a0-769271fb231a", token: "10ee0a25a2395ff173363ef44ee0cbdcd81e19d5f1a4d451d2cfe2409db6e7fb", latitude: 49.2812277842772, longitude: -122.956075, radius: 10)

Soul.create(soulType: "testSoulType1", s3Key: "testS3Key", epoch: 1000000000, latitude: 10.0, longitude: 10.0, radius: 1, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "testS3Key", epoch: 1000000000, latitude: 10.0, longitude: 10.0, radius: 2, token: "10ee0a25a2395ff173363ef44ee0cbdcd81e19d5f1a4d451d2cfe2409db6e7fb", device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "testS3Key", epoch: 1000000000, latitude: 10.0, longitude: 10.0, radius: 3, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType4", s3Key: "testS3Key", epoch: 1000000000, latitude: 10.0, longitude: 10.0, radius: 4, token: "10ee0a25a2395ff173363ef44ee0cbdcd81e19d5f1a4d451d2cfe2409db6e7fb", device_id: 2)
Soul.create(soulType: "testSoulType5", s3Key: "testS3Key", epoch: 1000000000, latitude: 10.0, longitude: 10.0, radius: 5, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
