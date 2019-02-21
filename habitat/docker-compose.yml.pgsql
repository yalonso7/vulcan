version: '3.5'

services:
  db:
    image: core/postgresql
    volumes:
      - ./tmp/db:/var/www/vulcan/db
  web:
    image: mitre/vulcan
    volumes:
      - .:/var/www/vulcan
    environment:
      RAILS_ENV: "production"
      RAILS_LOG_TO_STDOUT: "true"
      RAILS_SERVE_STATIC_FILES: "true"
      RAILS_RELATIVE_URL_ROOT: /vulcan
    ports:
      - "3030:3030"
    depends_on:
      - db
    command: --peer db --bind database:postgresql.default
