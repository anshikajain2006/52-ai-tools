Run Anshika Jain's daily outreach SCRAPE job. This job NEVER sends email. It finds and verifies candidates, queues LinkedIn contacts, and stores verified emails for the send job.

WHO YOU ARE PITCHING AS: Anshika Jain, CS undergrad at Krea University (graduating May 2027), looking for remote Founder's Office, Strategic Ops, Chief of Staff, or Growth/Analytics roles starting May 2027. Portfolio: anshika-jain.vercel.app (plain text only).

HARD RULES
- Never contact anyone at an edtech company (tutoring, test prep, college admissions, online courses, coding bootcamps, e-learning). Drop at first sign.
- Lumiere check: for each contact search "[contact name] Lumiere Education" on LinkedIn. Any connection or past employment at Lumiere Education: drop the company. Also fetch Google Drive file 14f17rI8yZlofuVOAZ8aZdFDSBq0c8bM7 (blocklist) and skip anyone named in it.
- Never mention Matrix Media Solutions or Matrix SG.
- Duplicates: read the outreach log sheet 1_-G4P0ysiu_Sr4yGy1xzJ4FVNhBJZIWhtntBB-3jAFo (Sheet1: Arrangr, Comograph, Sundream already contacted) and the tracker collections "emails" and "pending". Never queue the same company twice.
- Email: only use an address that appears VERBATIM in the raw content of a public URL you fetched in this run (company site team/contact/privacy/terms/press pages, YC page, LinkedIn profile visible without login, personal site, X bio, HN profile, GitHub commit metadata). Never guess from a name pattern. Never probe SMTP. One contact per company. No generic inboxes.
- LINKEDIN IS QUEUED EVEN WHEN NO EMAIL IS FOUND. A company with no verified email still gets its contact's LinkedIn queued with email_sent = "no". Find the profile from public sources only (company team page, YC page, search results showing public profile URLs). Confirm the profile loads publicly and the name and title match the company. If you cannot confirm it, skip that contact. Do not scrape LinkedIn at scale, do not log in, do not send any LinkedIn message.
- Every company needs ONE specific, nameable signal (a job posting showing an ops gap, a recent funding round and what it implies, a product launch or market expansion, a hiring pattern, or a visible bottleneck). If none surfaces in about 3 minutes, drop it. No generic signals.

TARGET: about 75 candidates per run from HN "Who is hiring" (current and last month), workatastartup.com, wellfound.com, remoteok.com, LinkedIn jobs (no login), YC W25/S25/W26/S26 pages, TechCrunch/Crunchbase News funding in the last 90 days, and Sequoia Surge, Accel India, Blume and Peak XV portfolios. Target remote-friendly startups under about 150 people, seed to Series B, India/Singapore/UAE/US/EU or remote-global. Skip Product Hunt and weworkremotely (they return 403 here).

WHAT TO WRITE
1. For each company with a verified email AND a signal: add a doc to the ArtifactData collection "pending" in the tracker artifact https://claude.ai/artifact/65p1M3Gu93Anff959xyN7m, using "batch" writes. Doc id = company slug. Fields: company, contact_name, contact_email, email_source_url, subject (under 8 words, specific to the signal), body (under 60 words, plain text, shape: greeting, one signal sentence, the Krea / Founder's Office ask, "Reply no if it's not a fit.", signature, anshika-jain.vercel.app), signal_used, queued_on (YYYY-MM-DD, IST), status = "queued". No em or en dashes, no square brackets, no placeholders in body.
2. For every contact with a confirmed LinkedIn profile (with or without email): add a doc to collection "linkedin", doc id = company slug. Fields: date (YYYY-MM-DD, IST), company, contact_name, contact_title, linkedin_url, signal_used, email_sent ("yes" only after the send job sends, "no" on scrape). Never overwrite a row whose email_sent is already "yes".
3. Read "emails" and "pending" first so nothing is duplicated. Pin updates with if_version.

Finish with exactly two lines:
Queued email: X to [companies] | LinkedIn: Y contacts
Dropped: Z companies, reasons (no verified email, no signal, edtech, Lumiere, duplicate, LinkedIn unconfirmed)
