# README

Description    
- - - - - - - - - - - - - - - - - - -  
Application is a properties listing web site which brings together property sellers/landlords and home seekers/rentees together, so that they may transact deals.  
<br>
<br>
For demo, click [here](https://minghuei.com)
<br>
<br>
Steps necessary to get application up and running.  
- - - - - - - - - - - - - - - - - - -  
The steps are:  

Linux os assumed => Ubuntu server 12.04.5  

Ruby version 2.2.4p assumed.  

Rails rails-5.0.1 will be used,  
and be downloaded and installed, in gems download and installation step shortly.  

Postgres database 9.3 assumed up and running.  
Postgres pg gem will be downloaded and installed, in gems download and installation step shortly.  

ImageMagick assumed installed.

Download application to your present working directory => git clone https://github.com/meng222555/hd.git  
This creates a directory named hd in your present working directory.  
Change into hd directory => cd hd  

Download and install gems indicated in Gemfile, based on the versions of dependencies found in Gemfile.lock =>  
bundle install --deployment  
This creates a directory named vendor under hd  
Gems are downloaded and installed to vendor/bundle/ruby/2.2.0/gems  

Open file config/application.yml  
Edit accordingly and save, using as reference the file application.yml_SAMPLE_dev_url_http_ip_addr.  
In particular, at username under development database section, provide a valid postgres user account ( with / without password) that has privilege to CREATE DATABASE.  

Create the database indicated under development database section of application.yml =>  
bundle exec rake db:create  

Create database tables => bundle exec rake db:migrate  

Launch application => bundle exec rails s -b 0.0.0.0  

Open a browser.  
To surf to application site, enter following url  
http://192.168.44.44:3000  
where 192.168.44.44 is ip address of my Rails box.  
You should replace the ip with that of your Rails box instead.  
