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

Soul.create(soulType: "testSoulType1", s3Key: "7ct3qs5FBQ0N7BQ2a3qo2zZ5hsSABDE4LqUpZfMlA0ZSV8ctNL9eMFQ1FRM7YS6", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 1, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "EDOyQ3xQjq624MTgMKqHgNFgjiUbVfv39lowr8s3uD5dOg5j4xhiTTOMqhHHeBk", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 2, token: "c58966dd88bdd4f355166756e93146e8d3ac8c506656d0f3d348a3c0d2f5157f", device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "IqqmKXwFCY30RheztvN06A4PU4m09caRCB6IdWROZ68UMwhKhVJumk1VbtqJKaN", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 3, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType4", s3Key: "1482718872", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 4, token: "c58966dd88bdd4f355166756e93146e8d3ac8c506656d0f3d348a3c0d2f5157f", device_id: 2)
Soul.create(soulType: "testSoulType5", s3Key: "1482708918", epoch: Time.now.to_i, latitude: 49.2812277842772, longitude: -122.956075, radius: 5, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)

