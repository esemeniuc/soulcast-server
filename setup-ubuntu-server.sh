#!/bin/bash

$HOMEDIR = echo $HOME
#need this for loading up environment variables
echo "Please enter in the url for the the environment vars script (look in Google Sheets): "
read $environment_vars
echo "Please enter in the url for the the nginx config (look in Google Sheets): "
read $nginx_config
echo "You entered nginx_config = $nginx_config"

#Setting up rails on a new system
sudo apt-get update -qq && sudo apt-get upgrade --yes #installs updates on server
sudo apt-get install curl

###install nodejs (required for rails)
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

###install and setup nginx
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get install nginx-light

sudo wget $nginx_config -O /etc/nginx/sites-available/soulcast.ml

sudo ln -s /etc/nginx/sites-available/soulcast.ml /etc/nginx/sites-enabled/soulcast.ml
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx start

###this installs RVM and Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install rails
gem install puma

###make new web folder
mkdir ~/soulcast.ml && cd ~/soulcast.ml

###set up deploy script
echo "#Deploy and start script
git pull https://github.com/cwaffles/soulcast-server.git
wget $environment_vars -O /etc/init.d/soulcast-server-startup.sh
sudo update-rc.d soulcast-server-startup defaults
rake db:reset RAILS_ENV=production
rake assets:clobber RAILS_ENV=production
rake assets:precompile RAILS_ENV=production

#make new tmux session for running 'rails server'
tmux new -d -c ~/soulcast.domain/soulcast-server -s rails_server 'pumactl start'
tmux new -s rails-server -c ~/soulcast.domain/soulcast-server" > ~/deploy.sh

~/deploy.sh #run deployment to start downloading everything
