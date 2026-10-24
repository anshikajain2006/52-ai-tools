# Outreach pipeline

Two jobs, run headlessly with Claude Code:

| Job | When | What it does |
|---|---|---|
| `scrape` | every day, 14:00 IST | Finds candidates, verifies emails, queues LinkedIn contacts. Never sends. |
| `send` | every day, 14:30 IST (skips Sat and Sun) | Sends queued emails, then D+3 and D+7 follow-ups in the same threads. |

The job prompts live in `.claude/commands/outreach-scrape.md` and `.claude/commands/outreach-send.md`.
The tracker is the ArtifactData database behind https://claude.ai/artifact/65p1M3Gu93Anff959xyN7m (collections `pending`, `emails`, `linkedin`).

## Setup on the machine that runs it

1. Install Claude Code and log in.
2. In Claude Code, connect the **Gmail** and **Google Drive** connectors (`/mcp`), and sign in to both.
3. Check that the connector tool names match the allowlist in `outreach/run.sh` (`mcp__Gmail`, `mcp__Google_Drive`). Run `claude -p "/outreach-scrape"` once by hand first and read the log.
4. Schedule the jobs. Example crontab (`crontab -e`). Set the machine to IST, or use the times below as local time:

```
30 8 * * *   /path/to/52-ai-tools/outreach/run.sh scrape
0 9 * * * /path/to/52-ai-tools/outreach/run.sh send
```

Those lines are 14:00 and 14:30 IST expressed in UTC for a machine on UTC. On an IST machine use `0 14 * * *` and `30 14 * * *`.

Both jobs can run every day. `run.sh` exits without sending on Saturday and Sunday, so the send job only sends on weekdays.

Logs go to `outreach/logs/` (git-ignored). The machine must be awake at run time, because cron does not catch up on missed runs.

## Notes

- The sending job uses Gmail as the sender. Check the first few sends by reading the `emails` collection in the tracker.
- The runner passes `--allowedTools` so the jobs can run without prompts. Remove a tool from that list to stop it being used.

## Verification rules (current)

- An email must appear verbatim on a public URL the job fetched in that run (company pages, YC, LinkedIn profile visible without login, personal site, X bio, HN profile, GitHub commits).
- Generic inboxes (careers@, hello@, jobs@, recruiting@, contact@) are allowed under the same rule.
- Personal addresses are allowed only when the page ties the address to the named person's current role at that company.
- Onsite and hybrid companies are allowed. Remote-first is preferred.
- A company is never dropped only because its posted role is engineering. The signal must be about the company.
