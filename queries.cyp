MATCH (n:Package)
  WHERE n.name = 'react-app'
RETURN n

MATCH (n:Package)
RETURN DISTINCT size((n)-[:USES]->(:Package)) AS c
  ORDER BY c

MATCH (n:Package)
WITH n.name AS name, size((n)-[:USES]->(:Package)) AS c
  ORDER BY c
  WHERE c >= 10
RETURN name, c

MATCH (n:Package)
RETURN DISTINCT size((n)<-[:USES]-(:Package)) AS c
  ORDER BY c

MATCH (n:Package)
WITH n.name AS name, size((n)<-[:USES]-(:Package)) AS c
  WHERE c > 20
RETURN name, c
  ORDER BY c

MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
RETURN (n)<-[:USES]-(:Package)

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
WITH shortestPath((s)-[*1..20]->(o)) AS p
WITH size(p) AS s
RETURN DISTINCT s
  ORDER BY s

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
WITH s, o, shortestPath((s)-[*1..20]->(o)) AS p
  WHERE p IS NULL
RETURN s.name, o.name

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
  WHERE o.name = 'delegates'
RETURN shortestPath((s)-[*1..20]-(o))

// takes a while
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
RETURN shortestPath((s)-[*1..20]-(o)) AS p
//turn off auto linking, rerun

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
WITH shortestPath((s)-[*1..10]->(o)) AS p
WITH p, size(p) AS s
  WHERE s = 10
RETURN p
// try 9 and 8

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
RETURN shortestPath((s)-[*1..3]->(o))


MATCH (s:Package)
  WHERE s.name = 'react-app'
SET s:Anchor
RETURN s

MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
RETURN shortestPath((s)-[*1..3]->(o))

MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
RETURN (n)<-[:USES]-(:Package)<-[:USES]-(:Package)

MATCH(n:Package)
  WHERE n.name = 'babel-runtime' OR n.name = 'babel-types'
SET n:Locus

MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
MATCH p = (n)<-[:USES]-(m:Package)<-[:USES]-(:Package)
  WHERE NOT m.name =~ 'babel.*'
RETURN p

MATCH (s)-[r:USES]->(o)
  WHERE NOT s.name =~ 'babel.*'
RETURN s, r, o

//Versions
MATCH (n:Package)-[:VERSION]->(v:Version)
RETURN n, v
  LIMIT 1

MATCH (p:Package)
WITH size((p)-[:VERSION]->(:Version)) AS s
RETURN DISTINCT s
  ORDER BY s

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s = 0
RETURN p.name

MATCH (p:Package)
  WHERE p.name = 'negotiator'
RETURN p

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s = 4
MATCH (p)-[:USES]->(v:Version)
RETURN p, v

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s > 1
MATCH (p)-[:USES]->(v:Version)
RETURN p, v

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s > 1
MATCH (p)-[:USES]->(v:Version)
WITH p.name AS package, collect(v.name) AS versions
WITH package, versions, size(versions) AS c
RETURN package, versions
  ORDER BY c DESC

MATCH (s:Package)-[r:USES]->(o:Package)
  WHERE s.name = 'yargs'
RETURN s, r, o
