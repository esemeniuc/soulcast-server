# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", latitude: 49.2812277842772, longitude: -122.956075, radius: 10, os: 'ios')
Device.create(token: "c58966dd88bdd4f355166756e93146e8d3ac8c506656d0f3d348a3c0d2f5157f", latitude: 49.2812277842772, longitude: -122.956075, radius: 10, os: 'ios')
Device.create(token: "cokb_316jF4:APA91bG0lBda5_a8oiQVQyKODfTnCc9s-nBklDOeLa1PqBXo50i0aA1_hJACfWTBztSO46rZp8B3IZ77O180H8uYnoH0KFxsYLDAYOcyBf86O6sAOmAjJCkRAzpSgcoa13okNFPcuvwi", latitude: 49.2812277842772, longitude: -122.956075, radius: 10, os: 'android')

Soul.create(soulType: "testSoulType1", s3Key: "23QkETUPWwdpMIlDRRlOt6GwnjI4GGhMFZ968szxkhPFKVYj5aCnsDraPwD0szT.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 1, device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "74fLIF97vMR2uuStCDxJ8begArXWRD1eFK9kScfAujTQRV4mQnwYWhSQeev6aL8.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 2, device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "IqqmKXwFCY30RheztvN06A4PU4m09caRCB6IdWROZ68UMwhKhVJumk1VbtqJKaN.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 3, device_id: 1)
Soul.create(soulType: "testSoulType4", s3Key: "BOvFhgeGWhyPAbd1A9X1GZjiJVUY9acdKpBZOy8WGI5qTzT5SxvlCYe197NJ15Z.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 4, device_id: 2)
Soul.create(soulType: "testSoulType5", s3Key: "GWh1vCQU8tO8Wuq26qqyN3to2bZGwQoKLJv30Ovwt17T8eu0eZZNdVsf7Uy9cyo.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 5, device_id: 1)
Soul.create(soulType: "testSoulType6", s3Key: "1494795358254.mp3", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 5, device_id: 3)
