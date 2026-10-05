// List all indexed repositories
MATCH (r:Repository)
RETURN r.name, r.path, r.is_dependency
ORDER BY r.name;
