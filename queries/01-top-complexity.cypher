// Top 5 most complex functions by cyclomatic complexity
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND f.cyclomatic_complexity IS NOT NULL
RETURN f.name AS name, f.path AS path, f.line_number AS line,
       f.cyclomatic_complexity AS complexity
ORDER BY f.cyclomatic_complexity DESC
LIMIT 5;
