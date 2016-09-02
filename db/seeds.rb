# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/0e01488f-6278-392f-a77b-acfe8902a6ac", token: "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6")
Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/32efd1e1-2db3-3882-b5a0-769271fb231a", token: "d30f88899cb7641efebd470efa2dcf90aca278a8af088fd679b77adb6931563b")

Soul.create(soulType: "testSoulType1", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 1, token: "testToken", device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 2, token: "testToken", device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 3, token: "testToken", device_id: 1)
Soul.create(soulType: "testSoulType4", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 4, token: "testToken", device_id: 2)
Soul.create(soulType: "testSoulType5", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 5, token: "testToken", device_id: 1)
