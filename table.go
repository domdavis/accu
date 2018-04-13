package main

import "fmt"

type table struct{}

func (t *table) process(name, version, dep, semver string) error {
	fmt.Printf("%-30s %-10s %-30s %s\n", name, version, dep, semver)
	return nil
}
