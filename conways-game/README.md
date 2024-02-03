# README


## Secrets

Access repo settings to store Rails Secret Key Base.

Settings > Security > Secrets and variables > Codespaces

Click on New repository secret button and create a new variable called SECRET_KEY_BASE.

```
Name: SECRET_KEY_BASE

Secret: <RUN rails secret to get the secret_key_base value>
```

## Docker

To use Docker is also needed to make the steps to save SECRET_KEY_BASE on GitHub.

```
# Create image
docker-compose build

# Create database
docker-compose run api bundle exec rails db:create

# Create tables
docker-compose run api bundle exec rails db:migrate

# Start application
docker-compose up

# Run tests
docker-compose run api bundle exec rails db:environment:set RAILS_ENV=test
docker-compose run api bundle exec rspec spec/ 
```