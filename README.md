# ACCU 2018

## Starting Neo4j

```bash
docker kill neo4j; \
docker rm neo4j; \
docker run -d \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/password \
  --name neo4j neo4j
```

## Create a data source

https://github.com/facebook/create-react-app

```bash
npx create-react-app react-app
```

## Import the data

```bash
go build
accu -dir react-app -mode graph
```

## Play

Have a look at the [cypher](queries.cyp) for inspiration.
