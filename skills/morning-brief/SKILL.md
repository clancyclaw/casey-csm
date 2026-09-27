---
name: morning-brief
description: Casey's proactive rhythm. Setting up and changing the schedule (OpenClaw cron jobs via the openclaw CLI, with a heartbeat fallback), the weekday morning brief (who needs the founder today, renewals in 30/60/90 days, stalled onboardings, risk signals, pending drafts), midday follow-up nudges on promises, and the Friday weekly health report. Use for any casey:morning-brief, casey:nudges or casey:weekly-report message, for "brief", "who needs me", "weekly report", schedule or settings changes, and on heartbeats.
---
# Morning brief and the weekly rhythm

The brief is the reason the founder keeps you: one text each weekday morning
that says exactly who needs them and has the next move ready. It must be
worth reading on a lock screen.

## Set up the schedule

Do this at the end of first run and whenever the founder changes a time. The
Plow base gives you the `exec` tool but not the cron tool, so create OpenClaw
scheduler jobs with the `openclaw` CLI. Use the founder's IANA timezone and
the times in company.md.

```sh
openclaw cron add --name casey-morning-brief --cron "30 8 * * 1-5" --tz "America/New_York" --session main --system-event "casey:morning-brief" --wake now
openclaw cron add --name casey-nudges --cron "0 13 * * 1-5" --tz "America/New_York" --session main --system-event "casey:nudges" --wake now
openclaw cron add --name casey-weekly-report --cron "0 15 * * 5" --tz "America/New_York" --session main --system-event "casey:weekly-report" --wake now
openclaw cron list
```

- Before adding, run `openclaw cron list`; if a `casey-*` job exists, edit or
  remove it instead of adding a duplicate (`openclaw cron edit <id> --cron
  "..." --tz "..."`, `openclaw cron remove <id>`).
- If `--session main` with `--system-event` is rejected, use an isolated job
  instead: `--session isolated --message "casey:morning-brief" --no-deliver`
  (you then deliver with a message send to `plow-owner`, as for any
  unprompted turn).
- If the CLI is missing, cannot reach the gateway or is denied, do not try
  other routes. Use heartbeat mode: on each heartbeat, run any job that is
  scheduled for today, whose time has passed, and whose last run in
  `casey/schedule.md` is not today.
- Use exec only for these `openclaw cron` commands and harmless file work.
  Never print, store or send environment variables, tokens or passwords.

Record what is active in `casey/schedule.md`:

```
Mode: scheduler | isolated | heartbeat
Timezone: America/New_York
- casey-morning-brief | Mon-Fri 08:30 | job <id> | last run <date>
- casey-nudges | Mon-Fri 13:00 | job <id> | last run <date>
- casey-weekly-report | Fri 15:00 | job <id> | last run <date>
Renewal packs sent: <account-id> 90d <date>; 60d <date>; 30d <date>
Paused: no | until <date>
```

Tell the founder in one line which mode is on, e.g. "Briefs are scheduled for
8:30am ET on weekdays." In heartbeat mode say they can arrive up to about 30
minutes late.

## Running a scheduled job

A `casey:` message is a scheduled run. Check `casey/schedule.md`: if this job
already ran today, or the schedule is paused, reply `NO_REPLY`. Otherwise do
the job, deliver it with one message send to `plow-owner`, update "last run",
and make your final reply exactly `NO_REPLY`. Never send the same scheduled
job twice in a day. When the founder asks for a brief in their 1:1, just reply
normally; that does not count as the scheduled run.

## The morning brief (`casey:morning-brief`, or "brief")

Build it from files, not memory:

1. Read company.md, every account file, approvals.md and schedule.md.
2. Recompute health for every account (time moves "last touch").
3. Pick at most 3 accounts that need the founder today, ranked by: P1 issue;
   escalation or cancellation signal; renewal within 30 days not yet
   confirmed; health fell 10+ points since the last brief; promise we owe due
   today or overdue; champion silent 14+ days during onboarding or within 90
   days of renewal; onboarding milestone overdue. Tie-break by ARR.
4. For each, have the next move ready: a draft queued in approvals (check-in,
   nudge, update), a prep pack, or a specific ask of the founder.
5. List renewals in the next 30, 60 and 90 days with ARR, and stalled
   onboardings (no milestone progress in 7+ days). Compute days to renewal
   from each account file's renewal date and today's date in the founder's
   timezone, then bucket by number: 30d = 0-30 days, 60d = 31-60, 90d =
   61-90. An account goes in exactly one bucket. Check each placement against
   the days figure you show elsewhere in the same brief (41d belongs in 60d).
6. Check renewal-prep triggers (90/60/30 days, QBR within 14 days, churn
   signals) and include anything that fired.

The header count ("N need you today") must equal the number of numbered
accounts below it. Number only accounts that meet a step-3 criterion; a
healthy account with a routine question goes under "Waiting on you" or gets a
one-line mention, not a numbered slot. If none qualify, use the quiet-day
one-liner.

Format (aim for under 900 characters; plain text only: no markdown headers,
no **bold**, no bullets with asterisks, since SMS shows them literally):

```
Mon Sep 28 · 2 need you today
1) Acme · $24k · renews Nov 12 (45d) · health 58, down 13
Dana silent 12 days; SSO bug ACME-3 open 9 days.
Next: check-in drafted (A-14). "yes 14" sends it.
2) Northwind (SAMPLE) · $18k · renews in 41d · health 45
Export-fix ETA we promised Maya is 2 days late.
Next: ask Priya for an ETA? I can post in the team thread.
Renewals: 30d none · 60d Acme $24k, Northwind $18k (sample) · 90d Beta $8k
Onboarding: Gamma stuck on data import, day 18.
Waiting on you: A-11 (Beta QBR invite), 2 days.
Reply 1 or 2 for detail.
```

On a quiet day send a one-liner ("All quiet: 6 accounts healthy, next renewal
Beta in 83 days.") so the founder knows you checked. The sample account
appears only until it is deleted and is never counted in totals.

## Follow-up nudges (`casey:nudges`)

Scan every account for promises due today or overdue and not nudged today.

- Promises we owe: remind the founder or the owning teammate ("You told Dana
  you'd send the SOC 2 report today. Want me to draft the cover note?"). For
  a teammate, post in the team thread.
- Promises they owe: queue a friendly nudge to the customer as a draft (never
  more than one nudge per promise per 3 business days).
- Also flag threads with an unanswered customer question older than 4 working
  hours.

Group everything into one message. Mark each promise `nudged <date>`. If
nothing is due, `NO_REPLY`.

## Weekly health report (`casey:weekly-report`, or "weekly report")

Friday afternoon, for the founder (and the team thread if the founder asked):

```
Week of Sep 21 · 9 accounts · $212k ARR
Healthy 5 · Watch 3 ($61k) · At risk 1 ($24k)
Moved: Acme 71 to 58 (SSO bug, champion quiet); Delta 66 to 78 (added 10 seats)
Renewals next 90d: $50k across 3 accounts; 1 has no renewal conversation yet
Issues: 4 open (1 P2 over 7 days: ACME-3, owner Priya)
Promises: 6 kept, 1 late (SOC 2 report to Dana)
Me this week: 23 thread replies, 5 bugs routed, 9 drafts (8 sent, 1 edited)
Next week's plays:
1. Acme: exec check-in with their VP Ops before the renewal pack
2. Gamma: 30-minute import working session
3. Delta: expansion conversation while they're happy
```

Every number comes from the files. If a figure is unknown (ARR missing for
some accounts), say so: "ARR known for 7 of 9".

## Settings the founder can text

"brief at 7:45", "no brief on Mondays", "weekly report on Mondays", "pause
briefs until Oct 5", "quiet hours 9pm-7am", "strict mode on". Update
company.md, change the cron job, update schedule.md, and confirm in one line.
