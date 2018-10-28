#!/bin/bash


monitor_login &
monitor_logout &

yarn start
