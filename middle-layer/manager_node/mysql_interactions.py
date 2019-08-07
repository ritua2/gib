"""
BASICS

Interactions with MySQL
"""


import datetime
import mysql.connector as mysql_con
import os




# Returns the time format YYYY-MM-DD hh:mm:ss (UTC)
def timnow():
    return datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")



# Adds a job to MySQL
# ID (str): Preferably an UUID
# username (str)
# job_type (str)
# compile_commands, run_commands (arr) (str): Contains a list of commands
# job_type (str)
# location (str)
# modules (str): Space separated
# output_files (str): Space separated
# directory_location (str): Zipped directory name without .zip, always located at DIR_commonuser/jobs_left

def add_job(ID, username, compile_commands, run_commands, job_type, location, modules, output_files, directory_location, sc_system, sc_queue, n_cores, n_nodes):
    springIPT_db = mysql_con.connect(host = os.environ['URL_BASE'], port = 6603, user = os.environ["MYSQL_USER"],
                    password = os.environ["MYSQL_PASSWORD"], database = os.environ["MYSQL_DATABASE"])
    cursor = springIPT_db.cursor(buffered=True)

    insert_new_job = (
        "INSERT INTO jobs (id, username, compile_commands, run_commands, type, date_submitted, submission_method, status, modules, output_files, directory_location, sc_system, sc_queue, n_cores, n_nodes) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")


    [compile_commands_str, run_commands_str] = [None, None]
    if compile_commands != None:
        compile_commands_str = ";".join(compile_commands)
    
    if run_commands != None:
        run_commands_str = ";".join(run_commands)

    cursor.execute(insert_new_job, (ID, username, compile_commands_str, run_commands_str, job_type, timnow(), location, "Received by server", modules, output_files, directory_location, sc_system, sc_queue, n_cores, n_nodes) )
    springIPT_db.commit()
    cursor.close()
    springIPT_db.close()



# Gets the IP:Port information given the username and IP
def get_ip_port(username, IP):

    springIPT_db = mysql_con.connect(host = os.environ['URL_BASE'], port = 6603, user = os.environ["MYSQL_USER"],
                    password = os.environ["MYSQL_PASSWORD"], database = os.environ["MYSQL_DATABASE"])
    cursor = springIPT_db.cursor(buffered=True)

    query = ("SELECT user, ip FROM assignment WHERE user=%s AND ip LIKE %s")
    cursor.execute(query, (username, IP+":%"))

    for (obtained_user, obtained_ip_port) in cursor:

        springIPT_db.commit()
        cursor.close()
        springIPT_db.close()

        return [[obtained_user, obtained_ip_port], False]
    else:
        return ["User not present", True]


    springIPT_db.commit()
    cursor.close()
    springIPT_db.close()
