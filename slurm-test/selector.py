#!/usr/bin/python3.6

"""
BASICS

Filters the received files and saves those in a special location
"""


import os, sys, shutil
from flask import Flask, request
import redis
import zipfile
import uuid
import zipfile



r = redis.Redis(host=os.environ['CONDUCTOR_IP'], password=os.environ['CONDUCTOR_PASSWORD'], port=6379, db=0)
app = Flask(__name__)
DOWNLOAD_PATH = os.environ['output_data_path'] # Includes final '/'



# Receives a zip file
@app.route("/gib/upload/job", methods=['POST'])
def job_upload():

    IP_addr = request.environ['REMOTE_ADDR']
    if not valid_IP(IP_addr):
        return "INVALID IP"

    file = request.files['file']
    fnam = file.filename

    # Avoids empty filenames and those with commas
    if fnam == '':
       return 'INVALID, no file uploaded'
    if ',' in fnam:
       return "INVALID, no ',' allowed in filenames"

    # Saves the file
    new_name = str(uuid.uuid4())+".zip"
    file.save(DOWNLOAD_PATH+new_name)

    if not zipfile.is_zipfile(DOWNLOAD_PATH+new_name):
        os.remove(DOWNLOAD_PATH+new_name)
        return "INVALID, file is not zip"

    return 'Job succesfully uploaded'


# Checks if an IP is valid or not
def valid_IP(IP):
    if str.encode(IP) in r.keys():
        return True
    return False


# Designed to be run using gunicorn
if __name__ == '__main__':
    app.run()
