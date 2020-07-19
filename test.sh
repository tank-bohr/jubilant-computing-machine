#!/usr/bin/env bash

PIPE_NAME="test-pipe"

mkfifo $PIPE_NAME

./script.rb $PIPE_NAME&
PID=$!

# Wait some time while ruby come to life
sleep 1

RESULT=`echo "foo" | nc localhost 2200`

if [ "$RESULT" == 'oof' ]; then
  echo -e "\033[01;32mSUCCESS\033[00m"
  EXIT_CODE=0
else
  echo -e "\033[01;31mFAILURE\033[00m"
  EXIT_CODE=1
fi

echo "" > $PIPE_NAME

rm $PIPE_NAME

wait $PID
exit $EXIT_CODE
