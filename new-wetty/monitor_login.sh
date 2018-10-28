#!/bin/bash


# Checks that a file is not deleted


while true ; do
  inotifywait -e delete_self "/home/ipt/.profile" &&\
  cp /user_scripts/.profile  "/home/ipt/.profile"
done

