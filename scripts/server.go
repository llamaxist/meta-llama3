package main

import (
	"fmt"
	"net/http"
)

func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func main() {
	// Define the directory containing static files
	staticDir := "./model"

	// Create a file server handler
	fileServer := http.FileServer(http.Dir(staticDir))

	// Function to handle all requests
	handler := func(w http.ResponseWriter, r *http.Request) {
		enableCors(&w)
		// No CORS headers are set here intentionally
		fmt.Printf("%s\t%s\n", r.Method, r.URL)
		fileServer.ServeHTTP(w, r)
	}

	// Register the handler for all routes
	http.HandleFunc("/", handler)

	// Start the server
	port := ":8081"
	fmt.Println("Starting server on port " + port)
	err := http.ListenAndServe(port, nil)
	if err != nil {
		panic(err)
	}
}
