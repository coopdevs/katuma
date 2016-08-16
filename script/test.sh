#!/bin/bash

result=0

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
