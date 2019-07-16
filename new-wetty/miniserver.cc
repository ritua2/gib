#include <algorithm>
#include <curl/curl.h>
#include <functional>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <vector>



#include <dirent.h>
#include <fts.h>
#include <grp.h>
#include <pwd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>


#include "httplib.h"



using namespace httplib;
using std::cout;
using std::ofstream;
using std::string;
using std::vector;



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


// Same as above, but without checking subdirectories
string read_dir_no_subs(const string& base_path, string &final_string)
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

        if (is_dir(complete_path.c_str())){
            final_string.append(complete_path);
            final_string.append("/\n");
        } else {
            // Adds to the string
            final_string.append(complete_path);
            final_string.append("\n");
        }

    }
    closedir(dirp);
    return final_string;
}


// Given a string and a token, it returns a vector of strings split by said token
// Obtained from: https://stackoverflow.com/questions/5607589/right-way-to-split-an-stdstring-into-a-vectorstring
vector<string> split(string str, string token){
    vector<string>result;
    while(str.size()){
        int index = str.find(token);
        if(index!=string::npos){
            result.push_back(str.substr(0,index));
            str = str.substr(index+token.size());
            if(str.size()==0)result.push_back(str);
        }else{
            result.push_back(str);
            str = "";
        }
    }
    return result;
}



// Replaces a substring within another
// Based on: https://stackoverflow.com/questions/4643512/replace-substring-with-another-substring-c
void ReplaceStringInPlace(string& subject, string& search,
                          string& replace) {
    size_t pos = 0;
    while((pos = subject.find(search, pos)) != std::string::npos) {
         subject.replace(pos, search.length(), replace);
         pos += replace.length();
    }
}



// Reads a file into a string
string file_to_string(string filepath) {

    std::ifstream t(filepath.c_str());
    string output_str;

    t.seekg(0, std::ios::end);   
    output_str.reserve(t.tellg());
    t.seekg(0, std::ios::beg);

    output_str.assign((std::istreambuf_iterator<char>(t)),
                std::istreambuf_iterator<char>());

    // Removes tabs
    string tabs = "\t";
    string four_spaces = "    ";
    ReplaceStringInPlace(output_str, tabs, four_spaces);

    return output_str;
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



// Delete non-empty directory and all its contents
// Based on https://stackoverflow.com/questions/2256945/removing-a-non-empty-directory-programmatically-in-c-or-c
int recursive_delete(const char *dir)
{
    int ret = 0;
    FTS *ftsp = NULL;
    FTSENT *curr;

    // Cast needed (in C) because fts_open() takes a "char * const *", instead
    // of a "const char * const *", which is only allowed in C++. fts_open()
    // does not modify the argument.
    char *files[] = { (char *) dir, NULL };

    // FTS_NOCHDIR  - Avoid changing cwd, which could cause unexpected behavior
    //                in multithreaded programs
    // FTS_PHYSICAL - Don't follow symlinks. Prevents deletion of files outside
    //                of the specified directory
    // FTS_XDEV     - Don't cross filesystem boundaries
    ftsp = fts_open(files, FTS_NOCHDIR | FTS_PHYSICAL | FTS_XDEV, NULL);
    if (!ftsp) {
        fprintf(stderr, "%s: fts_open failed: %s\n", dir, strerror(errno));
        ret = -1;
        goto finish;
    }

    while ((curr = fts_read(ftsp))) {
        switch (curr->fts_info) {
        case FTS_NS:
        case FTS_DNR:
        case FTS_ERR:
            fprintf(stderr, "%s: fts_read error: %s\n",
                    curr->fts_accpath, strerror(curr->fts_errno));
            break;

        case FTS_DC:
        case FTS_DOT:
        case FTS_NSOK:
            // Not reached unless FTS_LOGICAL, FTS_SEEDOT, or FTS_NOSTAT were
            // passed to fts_open()
            break;

        case FTS_D:
            // Do nothing. Need depth-first search, so directories are deleted
            // in FTS_DP
            break;

        case FTS_DP:
        case FTS_F:
        case FTS_SL:
        case FTS_SLNONE:
        case FTS_DEFAULT:
            if (remove(curr->fts_accpath) < 0) {
                fprintf(stderr, "%s: Failed to remove: %s\n",
                        curr->fts_path, strerror(errno));
                ret = -1;
            }
            break;
        }
    }

finish:
    if (ftsp) {
        fts_close(ftsp);
    }

    return ret;
}



// Posts a file to a given URL
// Based on https://cboard.cprogramming.com/networking-device-communication/76842-file-upload-libcurl.html
int post_file(string full_file_path, string url_to_post) {

    curl_httppost* post = NULL;
    curl_httppost* last = NULL;

    CURL *curl;
    curl = curl_easy_init();
    curl_formadd(&post, &last, 
        CURLFORM_COPYNAME, "file",
        CURLFORM_FILE, full_file_path.c_str(),
        CURLFORM_END);

 
    curl_easy_setopt(curl, CURLOPT_URL, url_to_post.c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPPOST, post);
 
    CURLcode res = curl_easy_perform(curl);
    if(res) {
        return 0;
    }
     
    curl_formfree(post);
    curl_easy_cleanup(curl);
}



// chown, based on https://stackoverflow.com/questions/8778834/change-owner-and-group-in-c
void easy_chown(const char *file_path, const char *user_name, const char *group_name) {
    uid_t          uid;
    gid_t          gid;
    struct passwd *pwd;
    struct group  *grp;

    pwd = getpwnam(user_name);

    uid = pwd->pw_uid;

    grp = getgrnam(group_name);

    gid = grp->gr_gid;

    chown(file_path, uid, gid);
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



    // Leaves the container waiting
    svr.Post("/wait", [&](const auto& req, auto& res) {

        string provided_key = req.get_param_value("key");
        string username = req.get_param_value("username");

        if (provided_key == NEW_UUID) {

            string wait_key = random_string(32);

            // Creates a new file in /home/gib and adds a random string to it
            ofstream wait_file;
            wait_file.open ("/etc/wait.key");
            wait_file <<  wait_key;
            wait_file << "\n";
            wait_file << username;
            wait_file.close();

            res.set_content(wait_key.c_str(), "text/plain");

        } else {
            res.set_content("INVALID key", "text/plain");
        }
    });


    // Deletes the wait key
    svr.Get("/delete_wait", [](const Request & /*req*/, Response &res) {

        remove("/etc/wait.key");
        res.set_content("", "text/plain");
    });


    // Triggers the exit functionality of wetty
    /*
    Exit functionality:
        - Backs up user data in greyfish
        - Deletes user data from the container
        - Deletes gib directory
    */

    svr.Post("/user/purge", [&](const auto& req, auto& res) {

        string provided_key = req.get_param_value("key");
        string greyfish_key = req.get_param_value("gk");
        string username     = req.get_param_value("username");
        string gf_url       = req.get_param_value("greyfish_url");

        if (provided_key == NEW_UUID) {

            // Compresses the user data and pushes it to greyfish
            system("tar -zcf summary.tar.gz  /home/gib");
            
            string greyfish_url = "http://";
            greyfish_url.append(gf_url);
            greyfish_url.append(":2000/grey/upload_dir/");
            greyfish_url.append(greyfish_key);
            greyfish_url.append("/");
            greyfish_url.append(username);
            greyfish_url.append("/home++gib");

            post_file("summary.tar.gz", greyfish_url);
            download_loc.append("/download");

            remove("summary.tar.gz");

            // Gets a list of all files on /home/gib
            string empty_str1 = "";
            string home_gib_data = read_dir_no_subs("/home/gib/", empty_str1);

            // Removes the last character (\n)
            home_gib_data.pop_back();
            vector <string> vec_home_gib_data = split(home_gib_data, "\n");

            // Deletes every file and directory except: .bashrc, .bash_logout, .profile
            for (int qq=0; qq < vec_home_gib_data.size(); qq++){
                string data_in_question = vec_home_gib_data[qq];

                if (is_dir(data_in_question.c_str())) {
                    // Delete directories
                    recursive_delete(data_in_question.c_str());
                    continue;
                }

                // For files
                if ((data_in_question == "/home/gib/.bashrc") || (data_in_question == "/home/gib/.bash_logout") ||
                                 (data_in_question == "/home/gib/.profile")) {

                    continue;
                }
                remove(data_in_question.c_str());
            }

            res.set_content("Succesfully purged user data", "text/plain");

        } else {
            res.set_content("INVALID key", "text/plain");
        }
    });



    svr.listen("0.0.0.0", 3100);

    return 0;

}

