#!/bin/bash

echo "Please enter in aws_access_key_id (look in Google Sheets): "
read aws_access_key_id
echo "Please enter in aws_secret_access_key (look in Google Sheets): "
read aws_secret_access_key
echo "You entered aws_access_key_id = $aws_access_key_id"
echo "You entered aws_secret_access_key = $aws_secret_access_key"

#Setting up rails on a new system
sudo apt-get update -qq && sudo apt-get upgrade --yes #installs updates on server
sudo apt-get install curl

###install nodejs (required for rails)
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

###this installs RVM and Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install rails

###make new web folder (prepare for nginx)
###for debian, use the following as root: mkdir -p /var/www/soulcast.domain && cd /var/www/soulcast.domain
mkdir ~/soulcast.domain && cd ~/soulcast.domain

###make new rails app
rails new soulcast-server-dev
cd soulcast-server-dev

###add aws-sdk to end of gemfile
echo "gem 'aws-sdk', '~> 2'" >> soulcast-server-dev/Gemfile
bundle install

###Rails AWS access - Create file at ~/.aws/credentials and create config file for SNS at ~/.aws/config:
mkdir ~/.aws
echo "[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key" > ~/.aws/credentials
echo "[default]
region=us-west-2" > ~/.aws/config

###make scaffold for soul object and device model
###note dont make type:string (column named "type") or else get ActiveRecord::SubclassNotFound in SoulController#create
rails generate model device arn:string token:string
rails generate scaffold soul soulType:string s3Key:string epoch:integer longitude:float latitude:float radius:float token:string device:references

###go to app/controllers/souls_controller.rb, (under before_action :...), add this on line 3
skip_before_action :verify_authenticity_token, only: [:create] #for dev only, disables authenticity checking on create

###set up relationship between objects
echo "class Device < ApplicationRecord
  has_many :souls
end" > app/models/device.rb

###seed the db with some test data
echo 'Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/0e01488f-6278-392f-a77b-acfe8902a6ac", token: "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6")
Device.create(arn: "arn:aws:sns:us-west-2:692812027053:endpoint/APNS_SANDBOX/restappPA/32efd1e1-2db3-3882-b5a0-769271fb231a", token: "d30f88899cb7641efebd470efa2dcf90aca278a8af088fd679b77adb6931563b")

Soul.create(soulType: "testSoulType1", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 1, token: "testToken", device_id: 1)
Soul.create(soulType: "testSoulType2", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 2, token: "testToken", device_id: 2)
Soul.create(soulType: "testSoulType3", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 3, token: "testToken", device_id: 3)
Soul.create(soulType: "testSoulType4", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 4, token: "testToken", device_id: 4)
Soul.create(soulType: "testSoulType5", s3Key: "testS3Key", epoch: 1000000000, longitude: 10.0, latitude: 10.0, radius: 5, token: "testToken", device_id: 5)' >> db/seeds.rb

rails db:migrate
rails db:seed

###start up the server
rails server -b 0.0.0.0 -p 8000 #run on port 8000
