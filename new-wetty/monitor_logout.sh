#!/bin/bash


# Checks that a file is not deleted


while true ; do
  inotifywait -e delete_self "/home/ipt/.bash_logout" &&\
  cp /user_scripts/.bash_logout  "/home/ipt/.bash_logout"
done

