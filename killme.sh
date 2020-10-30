#!/bin/bash

jobPid=$(lsof -t -i :8080)
if (( "$jobPid" -ne "" )); then
    kill -9 $jobPid
fi