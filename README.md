# Exploring Codebases with CodeGraphContext

> Indexing Flask into a graph database and querying it through Claude Code to trace call chains, find dead code, and spot complex functions.

**By [Anshika Jain](https://github.com/anshikajain2006)** · March 2026

**Tool:** [CodeGraphContext](https://github.com/Shashankss1205/CodeGraphContext), an MCP server that indexes local codebases into a graph database (KùzuDB) and exposes them as tools for AI assistants
**Category:** Code Intelligence
**Pricing:** Free / Open Source

---

## Goal

Understand large codebases (Flask, LangChain) faster, without reading every file by hand. Specifically:

- trace function call chains
- find dead code
- measure cyclomatic complexity

---

## Repo Structure

```
.
├── README.md                 # This writeup
├── mcp-config.example.json   # MCP server entry for Claude Code / VS Code
├── queries/                  # Cypher queries used in this project
│   ├── 01-top-complexity.cypher
│   ├── 02-find-function.cypher
│   ├── 03-direct-callers.cypher
│   ├── 04-outgoing-calls.cypher
│   ├── 05-dead-code.cypher
│   ├── 06-symbol-references.cypher
│   └── 07-list-repositories.cypher
└── screenshots/              # Query results
```

---

## Setup

```bash
# Install
pip install codegraphcontext

# Windows: required to avoid an encoding crash on the ✓ character
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8

# Index a codebase
cgc index /path/to/your/repo

# Start the MCP server
cgc mcp start
```

To use it from Claude Code or VS Code, add the server to your `.claude.json`. See [`mcp-config.example.json`](mcp-config.example.json):

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

> **Windows gotcha:** VS Code restarts the MCP server automatically, and the server holds an exclusive KùzuDB lock. To run CLI commands, kill `cgc.exe` first, run your command, then let VS Code restart it.

---

## What I Did

- Indexed the Flask `src/` directory into a KùzuDB graph (~10 min)
- Attempted LangChain `libs/`, but killed it mid-index because it was too large (no progress indicator)
- Queried for the 5 most complex functions by cyclomatic complexity
- Traced the full `url_for` call chain across `helpers.py` and `app.py`
- Found every function that calls `url_for` and mapped its upstream/downstream dependencies
- Ran a dead code analysis across the entire Flask codebase (14 candidates → 0 true dead code after filtering)
- Traced the full blueprint registration dependency tree

---

## Queries

All queries were run by asking Claude Code directly (via MCP), or by hitting KùzuDB from Python when the MCP server held the lock. Each one is also saved as a file in [`queries/`](queries/).

| Query | What it does |
|-------|--------------|
| [`01-top-complexity`](queries/01-top-complexity.cypher) | Top 5 functions by cyclomatic complexity |
| [`02-find-function`](queries/02-find-function.cypher) | Look up a function (and its source) by name |
| [`03-direct-callers`](queries/03-direct-callers.cypher) | Every function that calls a given function |
| [`04-outgoing-calls`](queries/04-outgoing-calls.cypher) | Everything a given function calls |
| [`05-dead-code`](queries/05-dead-code.cypher) | Functions with no incoming `CALLS` edges |
| [`06-symbol-references`](queries/06-symbol-references.cypher) | Functions whose source mentions a symbol (grep-over-graph) |
| [`07-list-repositories`](queries/07-list-repositories.cypher) | All indexed repositories |

**Example: top 5 most complex functions**

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

**Example: dead code (functions nothing calls)**

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

---

## Screenshots

![Cyclomatic complexity: top 5 functions](screenshots/cyclomatic-complexity.png)

![url_for call chain trace](screenshots/url-for-call-chain.png)

---

## What Worked

- Graph-based queries are genuinely powerful for tracing multi-hop call chains
- Cyclomatic complexity is stored per function, which makes "where should I refactor?" a one-line query
- Works as a Claude Code MCP server, so queries come naturally as conversation
- KùzuDB is embedded (no separate server to run)
- Source code is stored in the graph, so you can grep-over-graph for patterns

---

## What Didn't Work

- **Windows encoding bug**: crashes on the `✓` character unless `PYTHONUTF8=1` is set
- **KùzuDB exclusive lock**: only one process can connect at a time, so the MCP server and CLI can't run simultaneously
- **Static analysis blind spots**: decorator applications (`@setupmethod`), Click callbacks, property accessors, and dynamic dispatch through proxies (`current_app`) are not captured as `CALLS` edges
- LangChain `libs/` was too large to index, with no progress indicator, so I had to kill it
- VS Code restarts the MCP server automatically, which re-acquires the lock and blocks CLI usage

---

## Verdict

**Would use again**, especially for onboarding onto unfamiliar codebases. The call chain tracing and complexity queries saved a lot of manual reading.

| Dimension | Score (1-5) |
|-----------|-------------|
| Ease of use | 3 |
| Power / depth | 5 |
| Value for money | 5 |
| Documentation | 3 |
| **Overall** | 4 |

---

## Notes

- Flask indexed in ~10 min with `PYTHONUTF8=1 PYTHONIOENCODING=utf-8 cgc index --force ...`
- LangChain `libs/` was killed mid-index. The old index had already been deleted before the kill, so LangChain is absent from the graph
- To query while the MCP server is running: `Stop-Process -Id <cgc_pid> -Force`, run the query, then let VS Code restart `cgc`
- KùzuDB path: `~/.codegraphcontext/kuzudb`
