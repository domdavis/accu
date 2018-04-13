package main

import (
	"flag"
	"log"
	"path/filepath"
)

func main() {
	var dir, mode string
	var p processor

	flag.StringVar(&dir, "dir", ".", "The directory to scan")
	flag.StringVar(&mode, "mode", "table", "The mode to run in (graph/table)")
	flag.Parse()

	v := &visitor{}
	log.Printf("Scanning %s", dir)

	if err := filepath.Walk(dir, v.visit); err != nil {
		log.Fatal(err)
	}

	if mode == "table" {
		p = &table{}
	} else {
		p = newGraph()
	}

	if err := v.process(p); err != nil {
		log.Fatal(err)
	}
}
