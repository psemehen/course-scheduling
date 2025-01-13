# Course Scheduling Application

## System Requirements

* Ruby version: 3.3.6
* Rails version: 8.0.1
* PostgreSQL database
* Redis (for caching)

## Local setup
1. Install `ruby` using rvm/rbenv.
2. Install dependencies `bundle install`.
3. Create db and run migrations `rails db:create db:migrate`
4. Seed the db `rails db:seed`
5. Run the server `rails s`. The application should now be running on `http://localhost:3000`.

## Local setup
This project uses RSpec for testing. To run the test suite use `bundle exec rspec`.

## Development
1. This project uses standard for linting. Run `standardrb` to check your code style and `standardrb --fix` to resolve 
offenses.
2. `brakeman` is used for security analysis. Run `bundle exec brakeman` to check for potential security issues.
3. `bullet` is configured for development to help detect N+1 queries and unused eager loading.

## Development
Redis is used for caching. Ensure Redis is running on your system.