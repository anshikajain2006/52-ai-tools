// Find a function by name
MATCH (f:Function)
WHERE f.name = 'url_for' AND f.path CONTAINS 'flask'
RETURN f.name, f.path, f.line_number, f.end_line, f.source;
