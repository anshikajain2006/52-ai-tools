// What a function calls (outgoing edges)
MATCH (f:Function)-[c:CALLS]->(target)
WHERE f.name = 'url_for' AND f.path CONTAINS 'app.py'
RETURN target.name, target.path, c.line_number, c.full_call_name
ORDER BY c.line_number;
