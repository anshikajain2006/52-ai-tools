Run Anshika Jain's outreach SEND job. It must not send on Saturday or Sunday (IST): if today is a weekend, stop and report that it was skipped. It sends emails only from rows the scrape job already verified. Do not search for new candidates here.

Tracker artifact: https://claude.ai/artifact/65p1M3Gu93Anff959xyN7m (ArtifactData database). Collections: "pending" (queued by scrape), "emails" (sent log), "linkedin" (manual queue).

STEP 1: SEND NEW QUEUED EMAILS. Read "pending" where status = "queued". For each doc:
- Skip it if its company already appears in "emails" (one contact per company, never contact twice).
- Send via Gmail as plain text (no HTML): subject and body from the doc, to contact_email. The portfolio URL stays plain text.
- Apply Gmail label "outreach/sent" (Label_3) to the new thread.
- Write an "emails" doc (id = company slug): company, contact_name, contact_email, email_source_url, subject, signal_used, thread_id, sent_on (YYYY-MM-DD, IST), d3_status = "pending", d7_status = "pending", status = "sent".
- Set the matching "linkedin" doc email_sent = "yes" if one exists. Set the "pending" doc status = "sent".

STEP 2: D+3 FOLLOW-UP. For each "emails" doc with d3_status = "pending" and sent_on at least 3 days ago: reply in the same Gmail thread (thread_id), one sentence referencing the original signal and offering a call, under 30 words, plain text. Set d3_status = "sent". Remove label "outreach/d3-due" (Label_4) if applied.

STEP 3: D+7 FOLLOW-UP. For each doc with d7_status = "pending", sent_on at least 7 days ago, and d3_status = "sent": reply in the same thread, one sentence under 20 words saying it is the last note. Set d7_status = "sent". Remove label "outreach/d7-due" (Label_5) if applied.

Label rules: apply "outreach/d3-due" or "outreach/d7-due" to threads whose follow-up is due and not yet sent; remove them once sent.

Hard rules: never send to an edtech company; never mention Matrix Media Solutions or Matrix SG; no em or en dashes in sent text; no square brackets or placeholders in sent text; if a doc is missing a field needed to send, skip it and report why.

Finish with exactly two lines:
Sent: X emails to [companies]. D+3: A. D+7: B.
Skipped: Y, reasons
