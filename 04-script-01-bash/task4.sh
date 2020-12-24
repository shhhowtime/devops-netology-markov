#!/usr/bin/env bash

function check {
  nc -zv -w 10 $1 80 &>/dev/null
  if [[ $? -ne 0 ]]
  then
    echo "Port 80 is unaccessible on address $1" > error
    exit
  fi
}

hosts=("192.168.0.1" "173.194.222.113" "87.250.250.242")
while [[ 1==1 ]]
do
  for host in ${hosts[@]}
  do
    check $host
  done
done
