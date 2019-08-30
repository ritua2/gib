#!/bin/bash

mkdir tmp-store-results


# Move all files
cp -r ./* tmp-store-results
rm tmp-store-results/tmp-store-results


cd tmp-store-results

tar -cvzf ../results_file.tar.gz .

mv ../results_file.tar.gz .

# Uploads to server

okey=$(cat ../orchestra_file)
manager_node=$(cat ../manager_node_file)
username=$(cat ../User_file)
jobID=$(cat ../jobID_file)

curl -F file=@results_file.tar.gz http://"$manager_node":5000/api/jobs/upload_results/user/"$username"/"$jobID"/key="$okey"

cd ..
rm -rf tmp-store-results
