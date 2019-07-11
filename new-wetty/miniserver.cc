#include <algorithm>
#include <functional>
#include <fstream>
#include <iostream>
#include <random>
#include <string>


#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "httplib.h"



using namespace httplib;
using std::cout;
using std::ofstream;
using std::string;



// True if a file is a directory
// Based on: http://forum.codecall.net/topic/68935-how-to-test-if-file-or-directory/
bool is_dir(const char* path) {
    struct stat buf;
    stat(path, &buf);
    return S_ISDIR(buf.st_mode);
}

// True if a file exists and is a file
// Based on: http://forum.codecall.net/topic/68935-how-to-test-if-file-or-directory/
bool is_file(const char* path) {
    struct stat buf;
    stat(path, &buf);
    return S_ISREG(buf.st_mode);
}


// base_path (string): Base path where the list starts, last character should be '/'
// final_string (string): Final string after which all output is appended

string read_directory(const string& base_path, string &final_string)
{
    DIR* dirp = opendir(base_path.c_str());
    struct dirent * dp;
    while ((dp = readdir(dirp)) != NULL) {

        // Prints the complete name of the directory
        string file_name =  dp->d_name;

        string complete_path = base_path;
        complete_path.append(file_name);

        // Ignores current and previous directories
        if ((file_name == ".") || (file_name == "..")){
            continue;
        }

        // If the file is a directory, it is recursive
        string possible_directory_path = complete_path;
        possible_directory_path.append("/");

        // Adds to the string
        final_string.append(complete_path);
        final_string.append("\n");

        if (is_dir(possible_directory_path.c_str())){
            read_directory(possible_directory_path, final_string);
        }
    }
    closedir(dirp);
    return final_string;
}



// Generates a random string
// Based on https://stackoverflow.com/questions/440133/how-do-i-create-a-random-alpha-numeric-string-in-c
string random_string( size_t length ) {
    auto randchar = []() -> char {
        const char charset[] =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";
        const size_t max_index = (sizeof(charset) - 1);
        return charset[ rand() % max_index ];
    };

    string str(length,0);
    std::generate_n( str.begin(), length, randchar );
    return str;
}



int main(void) {
    Server svr;

    // Reads the key
    std::ifstream infile("/root/autokey");
    string NEW_UUID;

    if (infile.good()){
        getline(infile, NEW_UUID);
    }

    infile.close();

    string url_loc = "/";
    url_loc.append(NEW_UUID);


    string list_user_files = url_loc;
    list_user_files.append("/list_user_files");

    // Sends a string with a list of all files and directories in /home/gib/, each in a new line
    svr.Get(list_user_files.c_str(), [](const Request & /*req*/, Response &res) {

        string empty_string = "";
        string contents = read_directory("/home/gib/", empty_string);

        res.set_content(contents.c_str(), "text/plain");
    });



    // Uploads a file
    string upload_loc = url_loc;
    upload_loc.append("/upload");

    svr.Post(upload_loc.c_str(), [&](const auto& req, auto& res) {
        auto size = req.files.size();
        auto ret = req.has_file("filename");
        const auto& file = req.get_file_value("filename");
        string filename = file.filename;
        auto body = req.body.substr(file.offset, file.length);

        string file_path_in_wetty = "/home/gib/";
        file_path_in_wetty.append(filename);

        // Writes contents to the file
        ofstream written_file(file_path_in_wetty);
        written_file << body;
        written_file.close();
    });



    // Downloads a file
    string download_loc = url_loc;
    download_loc.append("/download");

    svr.Post(download_loc.c_str(), [&](const auto& req, auto& res) {

        string file_path = req.get_param_value("filepath");

        if (is_file(file_path.c_str()) && (file_path.substr(0, 10) == "/home/gib/")) {

            string file_contents = "";
            detail::read_file(file_path, file_contents);
            res.set_content(file_contents.c_str(), "text/plain");
        } else {
            res.set_content("File does not exist", "text/plain");
        }

    });


    svr.Post("/wait", [&](const auto& req, auto& res) {

        string provided_key = req.get_param_value("key");

        if (provided_key == NEW_UUID) {

            string wait_key = random_string(32);

            // Creates a new file in /home/gib and adds a random string to it
            ofstream wait_file;
            wait_file.open ("/home/gib/wait.key");
            wait_file <<  wait_key;
            wait_file.close();

            res.set_content(wait_key.c_str(), "text/plain");

        } else {
            res.set_content("INVALID key", "text/plain");
        }
    });






    svr.listen("0.0.0.0", 3100);

    return 0;

}

