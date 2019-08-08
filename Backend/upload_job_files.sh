#!/bin/bash

mkdir tmp-store-results

# Loops through the provided inputs
for file_or_dir in "$@"
do
    mv "$file_or_dir" tmp-store-results/
done


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
