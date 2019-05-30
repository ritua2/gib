"""
BASICS

Contains a set of functions that are called accross the other APIs
"""

import os
import datetime, time
from pathlib import Path
from influxdb import InfluxDBClient


# Checks for correct codes
influx_logs = os.environ["influx_command"] == "influxd"
redis_active = os.environ["redis_command"] == "redis-server --requirepass $REDIS_AUTH"

if redis_active:

    import redis

    # Assigns each token to a valid ID
    r_tok = redis.Redis(host=os.environ['URL_BASE'], password=os.environ['REDIS_AUTH'], db=3)



# Checks if the provided user key is valid
def valid_key(ukey, username):

    if ukey == os.environ['greyfish_key']:
        return True

    if redis_active:
        if r_tok.get(ukey) == None:
            return False

        if r_tok.get(ukey).decode("UTF-8") == username:
            # Deletes the token since it is single use
            r_tok.delete(ukey)
            return True

    return False


# Creates a new key (new dir) in the dictionary
# fpl (arr) (str): Contains the list of subsequent directories
# exdic (dict)
def create_new_dirtag(fpl, exdic):

    # New working dictionary
    nwd = exdic

    for qq in range(0, len(fpl)-1):
        nwd = nwd[fpl[qq]]

    # Adds one at the end
    nwd[fpl[-1]] = {"files":[]}

    return exdic


# Returns a dictionary showing all the files in a directory (defaults to working directory)
def structure_in_json(PATH = '.'):

    FSJ = {PATH.split('/')[-1]:{"files":[]}}

    # Includes the current directory
    # Replaces everything before the user
    unpart = '/'.join(PATH.split('/')[:-1])+'/'

    for ff in [str(x).replace(unpart, '').split('/') for x in Path(PATH).glob('**/*')]:

        if os.path.isdir(unpart+'/'.join(ff)):
            create_new_dirtag(ff, FSJ)
            continue

        # Files get added to the list, files
        # Loops through the dict
        nwd = FSJ
        for hh in range(0, len(ff)-1):
            nwd = nwd[ff[hh]]

        nwd["files"].append(ff[-1])

    return FSJ



# Given two lists, returns those values that are lacking in the second
# Empty if list 2 contains those elements
def l2_contains_l1(l1, l2):
    return[elem for elem in l1 if elem not in l2]



# Returns a administrative client 
# Default refers to the basic grey server
def idb_admin(db='greyfish'):

    return InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_ADMIN_USER'], 
        password = os.environ['INFLUXDB_ADMIN_PASSWORD'], database = db)


# Returns an incfluxdb client with read-only access
def idb_reader(db='greyfish'):

    return InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_READ_USER'], 
        password = os.environ['INFLUXDB_READ_USER_PASSWORD'], database = db)


# Returns an incfluxdb client with write privileges
def idb_writer(db='greyfish'):

    return InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_WRITE_USER'], 
        password = os.environ['INFLUXDB_WRITE_USER_PASSWORD'], database = db)


# Returns a string in UTC time in the format YYYY-MM-DD HH:MM:SS.XXXXXX (where XXXXXX are microseconds)
def timformat():
    return datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")


# Logs a failed login
# logkey (str): Key used
# IP (str): IP used
# unam (str): username used
# action (str)
# due_to (str): Reason for failed login, most likely due to incorrect key

def failed_login(logkey, IP, unam, action, due_to="incorrect_key"):

    if influx_logs:
        FC = InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_WRITE_USER'], 
            password = os.environ['INFLUXDB_WRITE_USER_PASSWORD'], database = 'failed_login')

        # Finds if the user is valid or not
        # Searches the list of directories
        allowed_users = iter(f[4:] for f in os.listdir(os.environ["greyfish_path"]+"/sandbox"))
        if unam in allowed_users:
            valid_user="1"
        else:
            valid_user="0"

        FC.write_points([{
                        "measurement":"bad_credentials",
                        "tags":{
                                "id":unam,
                                "valid_account":valid_user,
                                "action":action,
                                "reason":due_to
                                },
                        "time":timformat(),
                        "fields":{
                                "client-IP":IP,
                                "logkey":logkey
                                }
                        }])
    else:
        pass


# Generic greyfish action
# action_id (str): ID of the pertaining action
# specs (str): Specific action detail
def greyfish_log(IP, unam, action, spec1=None, spec2=None, spec3=None):

    if influx_logs:
        glog = InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_WRITE_USER'], 
            password = os.environ['INFLUXDB_WRITE_USER_PASSWORD'], database = 'greyfish')

        glog.write_points([{
                        "measurement":"action_logs",
                        "tags":{
                                "id":unam,
                                "action":action,
                                "S1":spec1
                                },
                        "time":timformat(),
                        "fields":{
                                "client-IP":IP,
                                "S2":spec2,
                                "S3":spec3
                                }
                        }])
    else:
        pass



# Admin greyfish action
# self_identifier (str): Who the user identifies as while executing the action
# action_id (str): ID of the pertaining action
# specs (str): Specific action detail
def greyfish_admin_log(IP, self_identifier, action, spec1=None, spec2=None, spec3=None):

    if influx_logs:
        glog = InfluxDBClient(host = os.environ['URL_BASE'], port = 8086, username = os.environ['INFLUXDB_WRITE_USER'], 
            password = os.environ['INFLUXDB_WRITE_USER_PASSWORD'], database = 'greyfish')

        glog.write_points([{
                        "measurement":"admin_logs",
                        "tags":{
                                "id":self_identifier,
                                "action":action,
                                "S1":spec1
                                },
                        "time":timformat(),
                        "fields":{
                                "client-IP":IP,
                                "S2":spec2,
                                "S3":spec3
                                }
                        }])
    else:
        pass
