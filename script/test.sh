#!/bin/bash

result=0

bundle install --jobs=3 --retry=3 --deployment

bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:drop db:create db:migrate

for engine_name in $(ls -d engines/*/ | cut -f 2 -d '/'); do
  pushd engines/$engine_name > /dev/null
  ./script/test.sh
  result+=$?
  popd > /dev/null
done

if [ $result -eq 0 ]; then
  echo "SUCCESS"
else
  echo "FAILURE"
fi

exit $result
