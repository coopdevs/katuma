#!/bin/bash

exit_code=0
engine_name=`pwd | cut -f6 -d '/'`

echo "Running tests for $engine_name engine..."

bundle install --jobs=3 --retry=3 --deployment

bundle exec rspec spec

exit_code+=$?

exit $exit_code
