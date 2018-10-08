#! /bin/bash

# getting necessary information from configure file
# read README for more information
folder_to_check=$(grep FolderToCheck configure| cut -d"=" -f2)
show_all_job_ids_command=$(grep ShowAllJobIdsCommand configure | cut -d"=" -f2)
control_files_folder=$(grep ControlFilesFolder configure | cut -d"=" -f2)
unzip_files_folder=$(grep UnzipFilesFolder configure | cut -d"=" -f2) 
scheduling_system=$(grep ScheduleingSystem configure | cut -d"=" -f2)

currentdir=$(pwd)
# check to see if there are update in folder_to_check for compile job
if (ls $control_files_folder/current_compile_file_list > /dev/null 2> /dev/null ); then
	cp $control_files_folder/current_compile_file_list $control_files_folder/previous_compile_file_list  
else
	touch $control_files_folder/previous_compile_file_list 
fi 
ls -1r $folder_to_check/*compile.zip > $control_files_folder/current_compile_file_list

new_jobs=$(diff $control_files_folder/current_compile_file_list $control_files_folder/previous_compile_file_list  \
				| grep "^<" | cut -d" " -f2 )

# run all the new compile jobs 
for j in $new_jobs; do
	# unzip the compile zip file
	name=$(echo $j | rev | cut -d'/' -f1 | rev | cut -d'.' -f1  )
	unzip $j -d $unzip_files_folder/$name
	# executing the compile file
	cd $unzip_files_folder/$name
	./compile.sh 2> ErrorMessages.out 
	# sending back results
	zip -r ${name}_output.zip  $unzip_files_folder/$name
	curl -F file=@$unzip_files_folder/$name/${name}_output.zip http://129.114.17.116:2000/grey/upload/dev/commonuser/output
	
	cd $currentdir
done




MAXIMUM_RUNNING_JOBS=50

if (ls $control_files_folder/current_running_jobs > /dev/null 2> /dev/null ); then
	cp $control_files_folder/current_running_jobs $control_files_folder/previous_running_jobs
else 
	touch $control_files_folder/previous_running_jobs
fi
$show_all_job_ids_command > $control_files_folder/current_running_jobs 
current_running_jobs_num=$(cat $control_files_folder/current_running_jobs  | wc -l)
num_jobs_to_run=0

if [[ $current_running_jobs_num < $MAXIMUM_RUNNING_JOBS ]]; then
	#return results to clients for finished jobs
	finished_jobs=$(diff $control_files_folder/current_running_jobs $control_files_folder/previous_running_jobs\
					| grep "^>" | cut -d" " -f2)
	for j in $finished_jobs; do
		name=$(echo $j | rev | cut -d'/' -f1 | rev | cut -d'.' -f1  )
		zip -r $unzip_files_folder/$name/${name}_output.zip $unzip_files_folder/$name
		curl -F file=@$unzip_files_folder/$name/${name}_output.zip http://129.114.17.116:2000/grey/upload/dev/commonuser/output
	done
	#calucalte maximum number of new jobs to run
	num_jobs_to_run=$(( $MAXIMUM_RUNNING_JOBS - $current_running_jobs_num ))
fi
# check to see if there are update in folder_to_check for run job
if (ls $control_files_folder/current_run_file_list > /dev/null 2> /dev/null ); then
	cp $control_files_folder/current_run_file_list $control_files_folder/previous_run_file_list   
else
	touch $control_files_folder/previous_run_file_list
fi

ls -1r $folder_to_check/*run.zip > $control_files_folder/current_run_file_list

new_jobs=$(diff $control_files_folder/current_run_file_list $control_files_folder/previous_run_file_list  \
				| grep "^<" | cut -d" " -f2 )
# run all the new run jobs
for j in $new_jobs; do
	# check to see if the threshold of run jobs is reached
	# if so, does not perform any check or run for new run jobs
	if [[ $num_jobs_to_run == 0 ]]; then
		# removing the jobs that cannnot be run this time in the current run file list
		sed -i "/$j/ d" $control_files_folder/current_run_file_list
		continue
	fi

	# unzip the run zip file
	name=$(echo $j | rev | cut -d'/' -f1 | rev | cut -d'.' -f1  )
	unzip $j -d $unzip_files_folder/$name
	# run all the new run jobs (FIFO)
	cd $unzip_files_folder/$name
	if [[ $scheduling_system == "SLURM" ]]; then
		cp $currentdir/slurm_skeleton.sh $unzip_files_folder/$name/${name}_slurm_skeleton.sh
		cat run.sh >> ${name}_slurm_skeleton.sh
		sed -i "s/JOB_NAME/$name/g" ${name}_slurm_skeleton.sh
		sbatch ${name}_slurm_skeleton.sh
		# adding new job to the list of current_running_jobs
		echo $name >> $control_files_folder/current_running_jobs
	fi
	cd $currentdir
	(( num_jobs_to_run-- ))
done












