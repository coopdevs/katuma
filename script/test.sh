#!/bin/bash

RESULT=0

for engine_script in engines/*/script/test.sh; do
  pushd "$(dirname "${engine_script}")/.." > /dev/null
  ./script/test.sh
  RESULT+=$?
  popd > /dev/null
done

if [ ${RESULT} -eq 0 ]; then
  echo "SUCCESS"
else
  echo "FAILURE"
fi

exit ${RESULT}
