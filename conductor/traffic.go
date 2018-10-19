/*
BASICS

Redirects a user, doing all the necessary actions
Checks that a user is valid after login into wetty

*/


package main

import (
    "fmt"
    "github.com/gorilla/mux"
    "encoding/json"
    "net/http"
    "os"
)


// Process uploaded keys
type Provided_Parameters struct {
    // Actor identifier
    Sender string
    // Key used
    Key  string
}



var credential string = os.Getenv("orchestra_key")



func main(){

    r := mux.NewRouter()

    r.HandleFunc("/api/scripts/startup", Startup_supplier).Methods("GET")
    r.HandleFunc("/api/active", Checker).Methods("GET")
    r.HandleFunc("/api/assign/users/{user_id}", Assigner).Methods("POST")
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
     }

     sender := ppr.Sender
     key := ppr.Key

     if key == credential{
        // TODO TODO
     } else {
        fmt.Fprintf(w, "INVALID key")
     }

}



