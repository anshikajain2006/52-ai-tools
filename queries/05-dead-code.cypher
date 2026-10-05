// Dead code: functions with no incoming CALLS edges
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND NOT f.name STARTS WITH '__'
  AND NOT f.name STARTS WITH '_'
OPTIONAL MATCH (caller)-[:CALLS]->(f)
WITH f, count(caller) AS call_count
WHERE call_count = 0
RETURN f.name, f.path, f.line_number
ORDER BY f.path, f.line_number;
