Run Anshika Jain's daily outreach SCRAPE job. This job NEVER sends email. It finds and verifies candidates, queues LinkedIn contacts, and stores verified emails for the send job.

WHO YOU ARE PITCHING AS: Anshika Jain, CS undergrad at Krea University (graduating May 2027), looking for remote Founder's Office, Strategic Ops, Chief of Staff, or Growth/Analytics roles starting May 2027. Portfolio: anshika-jain.vercel.app (plain text only).

HARD RULES
- Never contact anyone at an edtech company (tutoring, test prep, college admissions, online courses, coding bootcamps, e-learning). Drop at first sign.
- Lumiere check: for each contact search "[contact name] Lumiere Education" on LinkedIn. Any connection or past employment at Lumiere Education: drop the company. Also fetch Google Drive file 14f17rI8yZlofuVOAZ8aZdFDSBq0c8bM7 (blocklist) and skip anyone named in it.
- Never mention Matrix Media Solutions or Matrix SG.
- Duplicates: read the outreach log sheet 1_-G4P0ysiu_Sr4yGy1xzJ4FVNhBJZIWhtntBB-3jAFo (Sheet1: Arrangr, Comograph, Sundream already contacted) and the tracker collections "emails" and "pending". Never queue the same company twice.
- Email: only use an address that appears VERBATIM in the raw content of a public URL you fetched in this run (company site team/contact/privacy/terms/press/careers pages, YC page, LinkedIn profile visible without login, personal site, X bio, HN profile, GitHub commit metadata, and the company's own job post on Hacker News "Who is hiring" threads, where the comment is posted by the company itself). Never guess from a name pattern. Never probe SMTP. One contact per company.
- Generic inboxes (careers@, hello@, jobs@, recruiting@, contact@) are allowed when they appear verbatim on a public URL as above.
- Personal addresses (gmail, outlook, etc.) are allowed only when the address appears verbatim on a public source that ties it to the named person at that company, and that person's current role there is confirmed. If the link is unclear, drop it.
- LINKEDIN IS QUEUED EVEN WHEN NO EMAIL IS FOUND. A company with no verified email still gets its contact's LinkedIn queued with email_sent = "no". LinkedIn itself cannot be fetched or rendered by any tool here (it blocks automated access), so "confirmed" means the linkedin.com/in/ URL was found on a public, non-LinkedIn page that ties it to this named person at this company: a YC company page (check for linkedin.com links in the page source), the company's own team/about page, or a personal site / X bio that lists it. Record which of those it came from in the row. Do not scrape LinkedIn.com itself, do not log in, do not send any LinkedIn message.
- Every company needs ONE specific, nameable signal about the COMPANY (a recent funding round and what it implies, a product launch or market expansion, a hiring pattern, a founding-level hire, or a visible bottleneck). If none surfaces in about 3 minutes, drop it. No generic signals.
- The posted role does not decide the outcome. An engineering opening is fine: it can still point to a company-level signal. Never drop a company just because its open role is engineering, or because the role is not ops or growth. The pitch is for Founder's Office, Growth or Analytics roles regardless of the posting.

Remote-first is preferred, but onsite or hybrid companies are fine.

TARGET: up to 75 candidates per run, but 75 is a ceiling, not a quota — never pad the list with companies that fail the signal or verification rules just to hit a number. Report the real count.

Work through sources in this order until either 75 is reached or all sources below are exhausted for the day:
1. HN "Who is hiring" threads, newest first, going back as many months as needed: https://news.ycombinator.com/item?id=49922569 (Oct 2026), https://news.ycombinator.com/item?id=49522897 (Sep 2026), then search "Ask HN: Who is hiring?" for the thread two months back, and so on, one further month each run if the current pool is exhausted. Fetch with curl against the raw item URL (the HTML contains every comment), not WebFetch. For each company post with an email, also check the company's own site for a second contact if the HN poster is a recruiter inbox with no named person.
2. YC company directory pages for W25/S25/W26/S26 batches (ycombinator.com/companies?batch=X) — fetch with curl, pull company site + LinkedIn links from each listing.
3. wellfound.com/jobs — fetch with curl (loads directly, no login needed for listings).
4. TechCrunch / Crunchbase News funding announcements, last 90 days, seed to Series B — use WebSearch, then verify the company's own site.
5. Sequoia Surge, Accel India, Blume, Peak XV portfolio pages for recent investments.

Skip Product Hunt, weworkremotely, and remoteok.com (they return 403, or in remoteok's case the public feed is mostly large companies and agencies, not the target stage — not worth the time). Target remote-friendly startups under about 150 people, seed to Series B, India/Singapore/UAE/US/EU or remote-global.

WHAT TO WRITE
1. For each company with a verified email AND a signal: add a doc to the ArtifactData collection "pending" in the tracker artifact https://claude.ai/artifact/65p1M3Gu93Anff959xyN7m, using "batch" writes. Doc id = company slug. Fields: company, contact_name, contact_email, email_source_url, subject (under 8 words, specific to the signal), body (under 60 words, plain text, shape: greeting, one signal sentence, the Krea / Founder's Office ask, "Reply no if it's not a fit.", signature, anshika-jain.vercel.app), signal_used, queued_on (YYYY-MM-DD, IST), status = "queued". No em or en dashes, no square brackets, no placeholders in body.
2. For every contact with a confirmed LinkedIn profile (with or without email): add a doc to collection "linkedin", doc id = company slug. Fields: date (YYYY-MM-DD, IST), company, contact_name, contact_title, linkedin_url, signal_used, email_sent ("yes" only after the send job sends, "no" on scrape). Never overwrite a row whose email_sent is already "yes".
3. Read "emails" and "pending" first so nothing is duplicated. Pin updates with if_version.

Finish with exactly two lines:
Queued email: X to [companies] | LinkedIn: Y contacts
Dropped: Z companies, reasons (no verified email, no signal, edtech, Lumiere, duplicate, LinkedIn unconfirmed)
