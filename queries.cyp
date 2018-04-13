// Explore the tree, limited due to size of problem space
MATCH (s:Package)-[r:USES]->(o:Package) RETURN s, r, o LIMIT 300

// Ensure our app is actually in there. You can explore from the node
MATCH (n:Package)
  WHERE n.name = 'react-app'
RETURN n

// Number of dependencies per package
MATCH (n:Package)
RETURN DISTINCT size((n)-[:USES]->(:Package)) AS c
  ORDER BY c

// Get the names of the worst offenders
MATCH (n:Package)
WITH n.name AS name, size((n)-[:USES]->(:Package)) AS c
  ORDER BY c
  WHERE c >= 10
RETURN name, c

// Get the number of packages using each dependencies
MATCH (n:Package)
RETURN DISTINCT size((n)<-[:USES]-(:Package)) AS c
  ORDER BY c

// Get the names of the worst offenders
MATCH (n:Package)
WITH n.name AS name, size((n)<-[:USES]-(:Package)) AS c
  WHERE c > 20
RETURN name, c
  ORDER BY c

// Direct view of the worst offender
MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
RETURN (n)<-[:USES]-(:Package)

// Find the various dependency chains
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

// List the dependencies giving no path
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
WITH s, o, shortestPath((s)-[*1..20]->(o)) AS p
  WHERE p IS NULL
RETURN s.name, o.name

// Look at one of the paths, removing directionality
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
  WHERE o.name = 'delegates'
RETURN shortestPath((s)-[*1..20]-(o))

// Just the out tree for react-app
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS len
  WHERE len = 0
RETURN shortestPath((s)-[*1..20]-(o)) AS p
LIMIT 100

// Lool at the longest chains
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
WITH shortestPath((s)-[:USES*1..10]->(o)) AS p
WITH p, size(p) AS s
  WHERE s = 10
RETURN p
// try 9 and 8

// Approach from the other side, not that we're missing a dependency from
// react-app
MATCH (s:Package)
  WHERE s.name = 'react-app'
WITH s
MATCH (o:Package)
WITH s, o, size((o)-[:USES]->(:Package)) AS c
  WHERE c = 0
RETURN shortestPath((s)-[:USES*1..3]->(o))

// Find the dependency. Shortest path is hiding it from us
MATCH (p:Package)
  WHERE p.name = 'react-app'
RETURN (p)-[:USES]->(:Package)-[:USES]->(:Package)

// Explore the most used package
MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
RETURN (n)<-[:USES]-(:Package)<-[:USES]-(:Package)

// Highlight the nodes we're interested in (rerun the previous query
MATCH(n:Package)
  WHERE n.name = 'babel-runtime' OR n.name = 'babel-types'
SET n:Locus

// Filter out the internals of the babel package
MATCH (n:Package)
WITH n, size((n)<-[:USES]-(:Package)) AS c
  WHERE c = 57
MATCH p = (n)<-[:USES]-(m:Package)-[:USES]-(:Package)
  WHERE NOT m.name =~ 'babel.*'
RETURN p

// It's not just babel though
MATCH (s:Package)-[r:USES]->(o:Package)
  WHERE NOT s.name =~ 'babel.*'
RETURN s, r, o
LIMIT 300

// The graph contains versions
MATCH (s:Package)-[r:VERSION]->(o:Version)
RETURN s, r, o
  LIMIT 1

// List the counts of versions we have for each package
MATCH (p:Package)
WITH size((p)-[:VERSION]->(:Version)) AS s
RETURN DISTINCT s
  ORDER BY s

// List which are giving zero versions
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
RETURN (p)-[:VERSION]->(:Version)

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s = 4
MATCH (p)<-[u:USES]-(d:Package)
RETURN p, u, d

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s = 4
MATCH (p)-[w:WANTS]->(d:Package)
RETURN p, w, d

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s > 1
RETURN (p)-[:VERSION]->(:Version)

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s > 1
MATCH (p)<-[u:USES]-(d:Package)
RETURN p, u, d

MATCH (p:Package)
WITH p, size((p)-[:VERSION]->(:Version)) AS s
  WHERE s > 1
MATCH (p)-[:VERSION]->(v:Version)
WITH p.name AS package, collect(v.name) AS versions
WITH package, versions, size(versions) AS c
RETURN package, versions
  ORDER BY c DESC

MATCH (s:Package)-[r:USES]->(o:Package)
  WHERE s.name = 'yargs'
RETURN s, r, o

MATCH (s:Package)-[r:WANTS]->(o:Package)
  WHERE s.name = 'yargs'
RETURN s, r, o
