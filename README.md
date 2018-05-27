URL Shortener - Rails and Cassandra

* Dependencies: Rails 4.2.1, Cassandra 3.0, Ruby 2.2.1

* Clone the repository
* Install the dependencies
* Run `bundle install`
* Run `RAILS_ENV=development rake cequel:reset`
* Start rails server and Start Creating Shortened URLs with UI

Run Rspec:

* Run `RAILS_ENV=test rake cequel:reset`
* Run `bundle exec rspec spec/controllers/shorten_urls_controller.rb`