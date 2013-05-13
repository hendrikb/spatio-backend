Spatio
======
Usage: ./pry.sh

About
-----
IT IS HEAVILY WORK IN PROGRESS.

Spatio is about to become a spatial-aware web service for a University Project. More Infos later.

Setup
-----
You need to have PostGIS installed and a database with postgis extension setup.
Copy config/db.yml.template to config/database.yml and specify your
credentials.

To create create and initialize the database tables type:
```
$> rake db:migrate
$> ruby db/seeds.rb
```

Deployment
----------

To run, have ruby 1.9 installed and type:
```
$> gem install bundler
$> bundle install

# Edit gui.rb and change the api_url setting according to your planned setup

# Start the API service:
$> ruby api.rb -p 4567

# Start the GUI service:
$> ruby gui.rb -p 4568

# Be aware that if you use RVM you might start the services using
#     bundle exec ruby <api|gui>.rb -p <desired port>

# Open the GUI: http://127.0.0.1:4568/
```
