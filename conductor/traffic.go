/*
BASICS
Redirects a user, doing all the necessary actions
Checks that a user is valid after login into wetty
*/


package main

import (
    "bytes"
    "fmt"
    "github.com/gorilla/mux"
    "github.com/go-redis/redis"
    "encoding/json"
    "net/http"
    "os"
    "strings"
    "time"
)


// Process uploaded keys
type Provided_Parameters struct {
    // Actor identifier
    Sender string
    // Key used
    Key  string
}



var credential string = os.Getenv("orchestra_key")
var redauth string = os.Getenv("REDIS_AUTH")


// Creates a redis client for keeping tracking of which user is on which 
// Uses redis hashes 
var r_occupied *redis.Client = redis.NewClient(&redis.Options{
    Addr: "0.0.0.0:6379",
    Password: redauth,
    DB:0,
    })


// Creates a temporary cache until user redirects
var r_redirect_cache *redis.Client = redis.NewClient(&redis.Options{
    Addr: "0.0.0.0:6379",
    Password: redauth,
    DB:1,
    })


// Stores user information before identifying with wetty
var r_before_id *redis.Client = redis.NewClient(&redis.Options{
    Addr: "0.0.0.0:6379",
    Password: redauth,
    DB:2,
    })


func main(){

    r := mux.NewRouter()

    r.HandleFunc("/api/scripts/startup", Startup_supplier).Methods("GET")
    r.HandleFunc("/api/active", Checker).Methods("GET")
    r.HandleFunc("/api/assign/users/{user_id}", Assigner).Methods("POST")
    r.HandleFunc("/api/redirect/users/{user_id}/{target_ip}", Redirect).Methods("GET")
    r.HandleFunc("/api/instance/attachme", Attachme).Methods("POST")
    http.Handle("/", r)


    // Always listening in port 5000
    http.ListenAndServe(":5000", r)
}


// Returns the startup script
func Startup_supplier(w http.ResponseWriter, r *http.Request) {
    http.ServeFile(w, r, "/scripts/startup.sh")
}


// Simple API check
func Checker(w http.ResponseWriter, r *http.Request){
    fmt.Fprintf(w, "Orchestration node is active")
}


// Validates a user, requires json information about the user
// Creates an empty redis key with information
// MUST BE ADDED IN THE FUTURE
func Assigner(w http.ResponseWriter, r *http.Request){

    UID := mux.Vars(r)["user_id"]

    var ppr Provided_Parameters

    err := json.NewDecoder(r.Body).Decode(&ppr)

    if err != nil {
        fmt.Fprintf(w, "POST parameters could not be parsed")
    } else {

        key := ppr.Key

        all_instances_occupied := true

        //reqip := ip_only(r.RemoteAddr)

        if valid_adm_passwd(key){
            instances := redkeys(r_occupied)

            for _, instance := range instances{
                    // Gets the instance available
                    ava, _ := r_occupied.HGet(instance, "Available").Result()

                    // Ignores instances currently inc cache
                    if stringInSlice(instance, redkeys(r_redirect_cache)){
                       continue
                    }

                    if ava=="Yes"{
                        // Sets the instance as occupied, server now has 20 s to redirect user
                        r_redirect_cache.Set(instance, UID, 20*time.Second)
                        fmt.Fprintf(w, "User assigned to: %s", instance)
                        all_instances_occupied = false
                        break
                    }
                }
            if all_instances_occupied{
                fmt.Fprintf(w, "INVALID: cannot assign user, all instances are occupied")
            }

        } else {
            fmt.Fprintf(w, "INVALID key")
        }
    }

}


// Redirects a user after an available IP has been provided to him
func Redirect (w http.ResponseWriter, r *http.Request){

    UID := mux.Vars(r)["user_id"]
    TIP := mux.Vars(r)["target_ip"]

    // Finds if the user is located at any instance
    expected_user, err := r_redirect_cache.Get(TIP).Result()
    _, e2 := r_before_id.Get(TIP).Result()
    if (err == redis.Nil) || (e2 != redis.Nil) {
        fmt.Fprintf(w, "INVALID: %s has already been assigned to another user", TIP)
    } else {

        if UID == expected_user {
            // Adds http:// to the user name
            var b  bytes.Buffer
            b.WriteString("http://")
            b.WriteString(TIP)

            http.Redirect(w, r, b.String(), 301)

        } else {
            fmt.Fprintf(w, "INVALID, %s is not the expected user", UID)
        }
    }
}


// Adds the caller IP as a wetty instance
func Attachme (w http.ResponseWriter, r *http.Request){
    var ppr Provided_Parameters

    err := json.NewDecoder(r.Body).Decode(&ppr)

    if err != nil {
        fmt.Fprintf(w, "POST parameters could not be parsed")
    } else {

        key := ppr.Key
        // Each IP has to identify itself
        sender_ID := ppr.Sender
        reqip := ip_only(r.RemoteAddr)

        if valid_adm_passwd(key){

            // All IPs are stored in Redis with the following data:
            // Available, id, current_user, whoami_count, address
            var new_instance = make(map[string]interface{})
            new_instance["Available"] = "Yes"
            new_instance["id"] = sender_ID
            new_instance["current_user"] = "Empty"
            new_instance["whoami_count"] = "0"
            new_instance["address"] = reqip

            _, e2 := r_occupied.HMSet(reqip, new_instance).Result()

            if e2 != nil {
                fmt.Fprintf(w, "Server error, Redis is not attached")
            }
            fmt.Fprintf(w, "Instance correctly attached")
        } else {
            fmt.Fprintf(w, "INVALID key")
        }
    }
}



// Checks if an administrative credential is valid
func valid_adm_passwd(apass string) bool{

    if apass == credential{
        return true
    }
    return false
}


// Splits the IP by :
func ip_only(provip string) string{
    return strings.Split(provip, ":")[0]
}


// Returns a string slice with all the redis keys
// reserver: Redis server
func redkeys(redserver *redis.Client) []string{

    // Disregard error
    b, _ := redserver.Keys("*").Result()
    return b
}


func stringInSlice(a string, list []string) bool {
    for _, b := range list {
        if b == a {
            return true
        }
    }
    return false
}