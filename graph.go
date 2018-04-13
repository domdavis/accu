package main

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
)

type statement struct {
	Statement  string            `json:"statement"`
	Parameters map[string]string `json:"parameters"`
}

type query struct {
	Statements []statement `json:"statements"`
}

var client = &http.Client{}

type neo4j struct {
	client *http.Client
}

const (
	url      = "http://localhost:7474/db/data/transaction/commit"
	user     = "neo4j"
	password = "password"

	create = "MERGE (s:Package {name: $name})\n" +
		"MERGE (s)-[:VERSION]->(:Version {name: $version})\n"

	link = "MATCH (s:Package {name: $name})\n" +
		"MERGE (o:Package {name: $dep})\n" +
		"MERGE (s)-[:USES]->(o)\n" +
		"MERGE (s)-[:WANTS {name: $semver}]->(o)\n"
	nameParameter    = "name"
	depParameter     = "dep"
	versionParameter = "version"
	semverParameter  = "semver"
)

func newGraph() *neo4j {
	return &neo4j{client: client}
}

func (n *neo4j) create(name, version string) error {
	log.Printf("Creating %s (%s)", name, version)
	query := query{Statements: []statement{{
		Statement: create,
		Parameters: map[string]string{
			nameParameter:    name,
			versionParameter: version,
		},
	}}}

	return n.send(query)
}

func (n *neo4j) link(name, version, dep, semver string) error {
	log.Printf("Mapping %s to %s", name, dep)
	query := query{Statements: []statement{{
		Statement: link,
		Parameters: map[string]string{
			nameParameter:    name,
			depParameter:     dep,
			versionParameter: version,
			semverParameter:  semver,
		},
	}}}

	return n.send(query)
}

func (n *neo4j) send(q query) error {
	b, err := json.Marshal(q)

	if err != nil {
		return err
	}

	req, err := http.NewRequest(http.MethodPost, url, bytes.NewReader(b))

	if err != nil {
		return err
	}

	req.SetBasicAuth(user, password)
	if res, err := n.client.Do(req); err != nil {
		log.Printf("Error: %s running %s", err.Error(), b)
		return err
	} else {
		res.Body.Close()
		return nil
	}
}
