package main

import (
	"encoding/json"
	"io/ioutil"
	"os"
)

type pkg struct {
	Name         string            `json:"name"`
	Version      string            `json:"version"`
	Dependencies map[string]string `json:"dependencies"`
}

type visitor struct {
	Packages []pkg
}

type processor interface {
	process(name, version, dependency, semver string) error
}

const pkgName = "package.json"

func (v *visitor) visit(path string, f os.FileInfo, err error) error {
	if err != nil || f.IsDir() || f.Name() != pkgName {
		return err
	} else if data, err := ioutil.ReadFile(path); err != nil {
		return err
	} else {
		return v.parse(data)
	}
}

func (v *visitor) parse(data []byte) error {
	var p pkg

	if err := json.Unmarshal(data, &p); err != nil {
		return err
	}

	v.Packages = append(v.Packages, p)
	return nil
}

func (v *visitor) process(p processor) error {
	for _, pkg := range v.Packages {
		for dep, v := range pkg.Dependencies {
			if err := p.process(pkg.Name, pkg.Version, dep, v); err != nil {
				return err
			}
		}
	}

	return nil
}
