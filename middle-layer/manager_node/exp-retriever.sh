#!/bin/bash


original_location=$PWD
working_directory=/gib/jobs
gk=greyfish
greyfish_ip=149.165.170.15




# Directory where files are stored
cd $working_directory


# Requests all pending job files from greyfish
curl http://$greyfish_ip:2000/grey/grey_dir/$gk/commonuser/jobs_left > jobs_left.tar.gz

tar -xzf jobs_left.tar.gz
rm jobs_left.tar.gz



# Iterates over each file
for job_file in ./*.zip; do
    
    # Removes the job file from greyfish itself
    curl http://$greyfish_ip:2000/grey/delete_file/$gk/$USER_ID/$job_file/jobs_left

    # Unzips the file
    unzip $job_file
    rm $job_file

    job_dir=${job_file::-4}


    cd $job_dir

    # Ensures that there is a meta.json to process
    if [ ! -f meta.json ]; then
        cd ..
        rm -r $job_dir
        continue
    fi


    # Parses the meta.json
    error_message="File or key do not exist"

    username=$(python3 json_parser.py meta.json User)
    number_compile=$(python3 json_parser.py meta.json CC)
    number_run=$(python3 json_parser.py meta.json RC)



    for i in $(seq 1 "$(($number_compile-1))"); 
    do 
        # Processes the compile commands
        compile_command=$(python3 json_parser.py meta.json C"$i")

    done

    for k in $(seq 1 "$(($number_run-1))"); 
    do 
        # Processes the run commands
        run_command=$(python3 json_parser.py meta.json R"$k")
    done



    cd ..
    rm -r $job_dir

done



# Exits and continues
cd $original_location

