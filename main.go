package main

import (
	"embed"
	_ "embed"
	"errors"
	"io/fs"
	"log"
	"net/http"
)

//go:embed public
var public embed.FS

func main() {
	sub, err := fs.Sub(public, "public")
	if err != nil {
		log.Fatalf("failed to get sub filesystem: %v", err)
	}

	log.Println("listening on :8080")
	if err = http.ListenAndServe(":8080", http.FileServer(http.FS(sub))); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Printf("failed to listen and serve: %v", err)
	}
}
