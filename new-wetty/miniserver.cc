#include <fstream>
#include <iostream>
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



int main(void) {
    Server svr;

    string url_loc = "/";
    url_loc.append(std::getenv("UUID_f10"));

    const char * url_loc_char = url_loc.c_str();

    // Sends a string with a list of all files and directories in /home/gib/, each in a new line
    svr.Get(url_loc_char, [](const Request & /*req*/, Response &res) {

        string empty_string = "";
        string contents = read_directory("/home/gib/", empty_string);

        res.set_content(contents.c_str(), "text/plain");
    });


    // Uploads a file
    svr.Post("/multipart", [&](const auto& req, auto& res) {
        auto size = req.files.size();
        auto ret = req.has_file("name1");
        const auto& file = req.get_file_value("name1");
        string filename = file.filename;
        auto body = req.body.substr(file.offset, file.length);

        string file_path_in_wetty = "/home/gib/";
        file_path_in_wetty.append(filename);

        // Writes contents to the file
        ofstream written_file(file_path_in_wetty);
        written_file << body;
        written_file.close();
    });


    svr.listen("0.0.0.0", 3100);
}

