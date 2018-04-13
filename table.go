package main

import "fmt"

type table struct{}

func (t *table) create(name, version string) error {
	fmt.Printf("Creating %-30s %-10s\n", name, version)
	return nil
}

func (t *table) link(_, _, dep, semver string) error {
	fmt.Printf("Linking %-30s %s\n", dep, semver)
	return nil
}
