# Exploring Codebases with CodeGraphContext

> Using a graph-backed MCP server to trace call chains, find dead code, and measure complexity in the Flask codebase — straight from Claude Code.

**By [Anshika Jain](https://github.com/anshikajain2006)** · March 2026

**Tool:** [CodeGraphContext](https://github.com/Shashankss1205/CodeGraphContext) — an MCP server that indexes local codebases into a graph database (KùzuDB) and exposes them as tools for AI assistants.
**Category:** Code Intelligence
**Pricing:** Free / Open Source

---

## The Goal

Understand large codebases (Flask, LangChain) faster — specifically tracing function call chains, finding dead code, and measuring cyclomatic complexity — without reading every file manually.

---

## Setup

```bash
# Install
pip install codegraphcontext

# Windows — required to avoid encoding crash on the ✓ character
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8

# Index a codebase
cgc index /path/to/your/repo

# Start MCP server (add to Claude Code / VS Code via .claude.json)
cgc mcp start
```

**.claude.json MCP entry:**
```json
"CodeGraphContext": {
  "command": "cgc",
  "args": ["mcp", "start"],
  "env": {
    "PYTHONUTF8": "1",
    "PYTHONIOENCODING": "utf-8"
  }
}
```

> **Windows gotcha:** VS Code restarts the MCP server automatically, which holds an exclusive KùzuDB lock. To run CLI commands, kill `cgc.exe` first, run your command, then let VS Code restart it.

---

## What I Did

- Indexed the Flask `src/` directory into a KùzuDB graph (~10 min)
- Attempted LangChain `libs/` — killed mid-index, too large (no progress indicator)
- Queried for the 5 most complex functions by cyclomatic complexity
- Traced the full `url_for` call chain across `helpers.py` and `app.py`
- Found every function that calls `url_for` and mapped its upstream/downstream dependencies
- Ran a dead code analysis across the entire Flask codebase (14 candidates → 0 true dead code after filtering)
- Traced the full blueprint registration dependency tree

---

## Queries

All queries were run by asking Claude Code directly (MCP) or by hitting KùzuDB via Python when the MCP server held the lock.

**Top 5 most complex functions by cyclomatic complexity:**
```cypher
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND f.cyclomatic_complexity IS NOT NULL
RETURN f.name AS name, f.path AS path, f.line_number AS line,
       f.cyclomatic_complexity AS complexity
ORDER BY f.cyclomatic_complexity DESC
LIMIT 5
```

**Find a function by name:**
```cypher
MATCH (f:Function)
WHERE f.name = 'url_for' AND f.path CONTAINS 'flask'
RETURN f.name, f.path, f.line_number, f.end_line, f.source
```

**Direct callers of a function:**
```cypher
MATCH (caller:Function)-[:CALLS]->(target:Function)
WHERE target.name = 'url_for'
RETURN caller.name, caller.path, caller.line_number
ORDER BY caller.path
```

**What a function calls (outgoing edges):**
```cypher
MATCH (f:Function)-[c:CALLS]->(target)
WHERE f.name = 'url_for' AND f.path CONTAINS 'app.py'
RETURN target.name, target.path, c.line_number, c.full_call_name
ORDER BY c.line_number
```

**Dead code — functions with no incoming CALLS edges:**
```cypher
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND NOT f.name STARTS WITH '__'
  AND NOT f.name STARTS WITH '_'
OPTIONAL MATCH (caller)-[:CALLS]->(f)
WITH f, count(caller) AS call_count
WHERE call_count = 0
RETURN f.name, f.path, f.line_number
ORDER BY f.path, f.line_number
```

**Functions referencing a specific internal symbol (grep-over-graph):**
```cypher
MATCH (f:Function)
WHERE f.path CONTAINS 'flask'
  AND f.is_dependency = false
  AND f.source CONTAINS 'deferred_functions'
RETURN f.name, f.path, f.line_number
ORDER BY f.path, f.line_number
```

**List all indexed repositories:**
```cypher
MATCH (r:Repository)
RETURN r.name, r.path, r.is_dependency
ORDER BY r.name
```

---

## Screenshots

![Cyclomatic complexity — top 5 functions](screenshots/cyclomatic-complexity.png)

![url_for call chain trace](screenshots/url-for-call-chain.png)

---

## What Worked

- Graph-based queries are genuinely powerful for tracing multi-hop call chains
- Cyclomatic complexity data is stored per function — great for quick "where should I refactor?" queries
- Works as a Claude Code MCP server — queries come naturally as conversation
- KùzuDB is embedded (no separate server to run)
- Source code stored in the graph means you can grep-over-graph for patterns

---

## What Didn't Work

- **Windows encoding bug**: crashes on `✓` character unless `PYTHONUTF8=1` is set
- **KùzuDB exclusive lock**: only one process can connect at a time — the MCP server and CLI can't run simultaneously
- **Static analysis blind spots**: decorator applications (`@setupmethod`), Click callbacks, property accessors, and dynamic dispatch through proxies (`current_app`) are not captured as CALLS edges
- LangChain `libs/` was too large to index — no progress indicator, had to kill it
- The MCP server is restarted by VS Code automatically, which re-acquires the lock and blocks CLI usage

---

## Verdict

**Would use again** — especially for onboarding onto unfamiliar codebases. The call chain tracing and complexity queries saved significant manual reading time.

| Dimension | Score (1-5) |
|-----------|-------------|
| Ease of use | 3 |
| Power / depth | 5 |
| Value for money | 5 |
| Documentation | 3 |
| **Overall** | 4 |

---

## Raw Notes

- Flask indexed in ~10 min with `PYTHONUTF8=1 PYTHONIOENCODING=utf-8 cgc index --force ...`
- LangChain `libs/` was killed mid-index — old index was already deleted before the kill, leaving it absent from the graph
- To query while MCP server is running: `Stop-Process -Id <cgc_pid> -Force`, run query, let VS Code restart cgc
- KùzuDB path: `~/.codegraphcontext/kuzudb`
