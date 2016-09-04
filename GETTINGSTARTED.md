###For local dev environments


```bash
#!/bin/bash
echo "Please enter in aws_access_key_id (look in Google Sheets): "
read aws_access_key_id
echo "Please enter in aws_secret_access_key (look in Google Sheets): "
read aws_secret_access_key
echo "You entered aws_access_key_id = $aws_access_key_id"
echo "You entered aws_secret_access_key = $aws_secret_access_key"

mkdir ~/.aws
echo "[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key" > ~/.aws/credentials
echo "[default]
region=us-west-2" > ~/.aws/config
```


##Ubuntu Setup Guide

###Get Docker Compose
```bash
sudo wget https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

###Set up Docker
```bash
echo "FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs use #note: -qq to suppress log
RUN mkdir /myapp    
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp" > Dockerfile

touch Gemfile.lock

echo "source 'https://rubygems.org'
gem 'rails', '5.0.0'" > Gemfile

echo "
version: '2'
services:
  db:
    image: postgres
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db" > docker-compose.yml

docker-compose run web rails new . --force --database=postgresql --skip-bundle
```
