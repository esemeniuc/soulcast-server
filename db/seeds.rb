# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", latitude: 49.2812277842772, longitude: -122.956075, radius: 10)
Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad", latitude: 49.2812277842772, longitude: -122.956075, radius: 10)

Soul.create(soulType: "testSoulType1", s3Key: "testS3Key", epoch: 1000000000, latitude: 49.2812277842772, longitude: -122.956075, radius: 1, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "testS3Key", epoch: 1000000000, latitude: 49.2812277842772, longitude: -122.956075, radius: 2, token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad", device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "testS3Key", epoch: 1000000000, latitude: 49.2812277842772, longitude: -122.956075, radius: 3, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
Soul.create(soulType: "testSoulType4", s3Key: "testS3Key", epoch: 1000000000, latitude: 49.2812277842772, longitude: -122.956075, radius: 4, token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad", device_id: 2)
Soul.create(soulType: "testSoulType5", s3Key: "testS3Key", epoch: 1000000000, latitude: 49.2812277842772, longitude: -122.956075, radius: 5, token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104", device_id: 1)
