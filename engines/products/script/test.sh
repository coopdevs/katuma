#!/bin/bash

exit_code=0
engine_name=$(pwd | rev | cut -d'/' -f1 | rev)

echo "Running tests for $engine_name engine..."

bundle install --jobs=3 --retry=3 | grep Installing

RAILS_ENV=test bundle exec rake db:drop db:create
RAILS_ENV=test bundle exec rake db:migrate

bundle exec rspec spec

exit_code+=$?

exit $exit_code
