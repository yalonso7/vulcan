# Getting Started

If you still need to install Vulcan, click [here](/install/)

## Install Dependencies and run Vulcan

Before running Vulcan on your preferred platform, you need to install the project's dependencies.

There are two options for setting up and running the environment

### Ruby

1. Navigate to the folder where Vulcan is saved
2. Run `build-essentials` to install dependencies
3. Run `bundle install`
4. Run `bundle exec rake db:create`
5. Run `bundle exec rake db:migrate`
6. Run `bundle exec rails server`
7. Navigate to `localhost:3030`

### Docker

#### Building Docker Containers

These steps need to be performed the first time you build the docker containers, and whenever you edit the code base.

1. Navigate to the folder where Vulcan is saved
2. Run `docker-compose build`
3. Run `docker-compose run web rake db:migrate`
4. Generate keys

#### Running Docker Containers

1. Run `docker-compose up`
2. Navigate to `localhost:3030`

#### Stopping the Containers

1. Run `docker-compose down`

#### Troubleshooting

If migrating the db doesn't work (#2 in Building Docker Containers), then run:

- `docker run -itv vulcan_sqlite-data:/srv/dat busybox /bin/sh`
- `docker container ls -a # Note the most recent container ID`
- `docker cp db/\* container_id:/var/www/vulcan/db/`
