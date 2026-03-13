# Week 01 — CodeGraphContext

> An MCP server that indexes local codebases into a graph database and exposes them as tools for AI assistants.

**Category:** Code Intelligence
**Website:** https://github.com/Shashankss1205/CodeGraphContext
**Pricing:** Free / Open Source
**Week of:** March 13, 2026

---

## What I Was Trying to Do

Understand large codebases (Flask, LangChain) faster — specifically tracing function call chains, finding dead code, and measuring cyclomatic complexity — without reading every file manually.

---

## What I Actually Did With It

- Indexed the Flask `src/` directory and the LangChain `libs/` directory into a KùzuDB graph
- Queried for the 5 most complex functions by cyclomatic complexity
- Traced the full `url_for` call chain across `helpers.py` and `app.py`
- Found every function that calls `url_for` and mapped its upstream/downstream dependencies
- Ran a dead code analysis across the entire Flask codebase (184 candidates → 0 true dead code after filtering)
- Traced the full blueprint registration dependency tree

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
- LangChain indexing took very long (large codebase) with no progress indicator
- The MCP server is restarted by VS Code automatically, which re-acquires the lock and blocks CLI usage

---

## Would I Use It Again?

**Yes** — especially for onboarding onto unfamiliar codebases. The call chain tracing and complexity queries saved significant manual reading time.

---

## Rating

| Dimension | Score (1-5) |
|-----------|-------------|
| Ease of use | 3 |
| Power / depth | 5 |
| Value for money | 5 |
| Documentation | 3 |
| **Overall** | 4 |

---

## Raw Notes

- Repo: `anshikajain2006/52-ai-tools`
- Flask indexed in ~10 min, LangChain was killed mid-index (too long)
- Workaround for Windows encoding: `PYTHONUTF8=1 PYTHONIOENCODING=utf-8 cgc index ...`
- To query while MCP server is running: kill cgc.exe, query, let VS Code restart it
