// Functions referencing a specific internal symbol (grep-over-graph)
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND f.source CONTAINS 'deferred_functions'
RETURN f.name, f.path, f.line_number
ORDER BY f.path, f.line_number;
