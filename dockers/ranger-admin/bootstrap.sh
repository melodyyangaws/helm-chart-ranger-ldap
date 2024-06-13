#!/bin/bash
set -xe
./setup.sh
# wait for postgresDB start up first
sleep 30
ranger-admin start
tail -f logfile