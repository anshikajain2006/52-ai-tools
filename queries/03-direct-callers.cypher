// Direct callers of a function
MATCH (caller:Function)-[:CALLS]->(target:Function)
WHERE target.name = 'url_for'
RETURN caller.name, caller.path, caller.line_number
ORDER BY caller.path;
