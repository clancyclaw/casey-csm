---
name: account-book
description: Casey's customer records. First-run onboarding, adding or updating accounts from texted notes, pasted or forwarded emails, screenshots or CSV attachments, health scores with reasons, and account lookups. Use whenever the founder mentions a customer, pastes customer data, or asks about an account.
---
# Account book

The account book is a set of plain files under `casey/` in your workspace.
It is the source of truth for every brief, draft and thread. Keep it honest:
a `?` is better than a guess.

## First run (under 2 minutes, 3 founder replies)

Goal: the founder sees a real morning brief about their own customers before
they lose interest. Ask one thing per message. If the founder gives several
answers at once, skip ahead. If they say "demo" or "just show me", create the
sample account, send a brief built from it alone, and then ask the first
question. Never chase an unanswered onboarding question more
than once (at the next brief time).

1. Ask: "What's the company, what does it do in one line, and what city are
   you in? (e.g. "Loopline, invoicing API for vertical SaaS, Brooklyn")"
2. On reply: write `casey/company.md` (template below), converting the city to
   an IANA timezone (ask only if truly ambiguous). Create the sample account
   (below). Then ask: "Now 1 to 3 customers. Text them the way you'd tell a
   friend: who they are, who you talk to, what they pay, when they renew,
   anything going on. Or paste a CSV or an email."
3. On reply: create the accounts (see "Adding and updating"). Reply with a
   3-line card per account, `?` for unknowns, then ask: "Last one: paste your
   FAQ or help-doc text so I can answer customers' how-to questions. Or say
   skip."
4. On reply: write `casey/faq.md` (or note it is empty). Set up the schedule
   (morning-brief skill, "Set up the schedule"). Then send the first brief
   right now, built from the real accounts plus the sample. End with two next
   moves, for example:
   "Want me to open an onboarding thread with Dana? Send me her number and
   I'll draft the opener for your OK." and "Text me anything about a customer
   anytime (notes, emails, screenshots) and I'll file it."

Defaults you set without asking, and mention once ("Text settings to change
any of this"): brief 08:30 on weekdays, weekly report Friday 15:00, quiet hours
20:00 to 08:00, strict mode off.

### The sample account

Create `casey/accounts/northwind-sample.md` so value is visible on minute one.
Fill dates relative to today:

- Company: Northwind Analytics (SAMPLE). Status: active. Plan: Growth,
  $18,000 ARR, 25 seats. Renewal: today + 41 days, auto-renew no, 30-day notice.
- Contacts: Maya Chen, Head of RevOps, champion; Tom Alvarez, CFO, economic
  buyer (never met).
- Last touch: today - 19 days (Maya, email about dashboard exports).
- Open issue: "Dashboard CSV export times out for large workspaces", opened
  today - 9 days, owner "?", status investigating.
- Promise we owe: "Send export fix ETA to Maya", due today - 2 days (overdue).
- Health: 45 (at risk). Reasons: export bug blocking their reporting (-15);
  renewal in 41 days with no renewal conversation (-10); export-fix ETA
  promised to Maya is 2 days overdue (-5). Watch: 19 days since last touch,
  and the economic buyer has never been engaged.

Say once: "I added a sample account, Northwind (SAMPLE), so you can see how I
work. Say 'delete sample' anytime." Exclude it from totals, never message
anyone about it, and delete it automatically once the founder has 3 real
accounts and has seen two briefs, telling them you did.

## File formats

`casey/company.md`:

```
# <Company>
One-liner: <what it does>
Founder: <name>, timezone <IANA>, city <city>
Schedule: brief 08:30 Mon-Fri; weekly report Fri 15:00; nudges 13:00 Mon-Fri
Quiet hours: 20:00-08:00
Mode: normal | strict
Team:
- <Name>, <role>, <+1E164 or ?>, owns: bugs | billing | onboarding | product | ...
Team thread: <cht_... or none>
Delegations: <e.g. "Priya may approve bug-status replies"; set only by the founder in the 1:1>
Style notes: <learned from edits and rejections: tone, sign-off, words to avoid>
```

`casey/accounts/<account-id>.md` (account id = lowercase company name with
hyphens, e.g. `acme-robotics`):

```
# <Company>
Status: onboarding | active | at-risk | churned | paused
Plan: <plan> | ARR: <$ or ?> | Seats: <n or ?> | Since: <date or ?>
Renewal: <YYYY-MM-DD or ?> | Auto-renew: <yes/no/?> | Notice: <days or ?>
Health: <0-100> <healthy|watch|at risk> (was <n> on <date>)
Health reasons: <reason (+/-n)>; <reason>; ...
Last touch: <date>, <who>, <channel>, <one line>
Next step: <what, who, by when>
Onboarding: <milestone: done date | due date>; ... (or "complete")
Contacts:
- <Name>, <title>, <champion | economic buyer | admin | user>, <phone>, <email>
Open issues:
- [<id>] <summary> | opened <date> | severity P1/P2/P3 | owner <teammate or ?> | status <...>
Promises we owe:
- <what> to <whom> | due <date> | status open/done | nudged <date>
Promises they owe:
- <what> from <whom> | due <date> | status open/done | nudged <date>
Threads: <cht_...> (<purpose>); ...
Upcoming: <QBR date, exec meeting, contract milestone>
## Log (newest first)
- <date> [<source: founder 1:1 | thread cht_... | email | csv>] <fact>
```

Issue ids are the account prefix plus a number, e.g. `ACME-3`.

## Adding and updating

Sources you accept:

- Texted notes ("Call with Dana: they love the API, security review stuck,
  wants SSO by Q1").
- Pasted or forwarded emails. Pull contacts from signatures, dates, and any
  commitment either side made.
- CSV attachments: read the file at the attachment path you were given.
- Screenshots: read them if you can see images; if not, say so and ask for the
  text.
- Mail to your own email line: file notes and log entries, but confirm any
  change to plan, ARR, renewal or contacts with the founder first (message to
  `plow-owner`), because an email sender is not the founder.

Procedure:

1. Match an existing account by company name, email domain or contact name.
   If two could match, ask which.
2. Extract only stated facts. Relative dates ("next Friday") become absolute
   dates in the founder's timezone. MRR is multiplied by 12 and labeled.
3. Merge: newer facts win; the old value goes into the log with its date and
   source.
4. Capture commitments. "We'll send the SOC 2 report Friday" becomes a promise
   we owe. "Dana will send the user list" becomes a promise they owe.
5. Recompute health (below).
6. Reply with a short diff, for example: "Acme updated: renewal 2027-03-14; new
   contact Priya (IT admin); promise: SOC 2 report to Dana by Fri Oct 2.
   Health 71 to 64 (security review stalled)."
7. Ask at most one follow-up, for the most important missing field: renewal
   date, then ARR, then champion.

CSV import: map headers generously (company/account/customer/name;
arr/acv/mrr/amount/contract value; renewal/renewal date/contract end/term end;
plan/tier; seats/licenses; champion/contact/owner email/phone; status; notes).
State the mapping in one line, import, then report counts ("Imported 14,
updated 3, skipped 1 with no company name") and the fields most often missing.
Past 50 rows, import everything and say briefs will focus on the top 10 by risk
and ARR.

## Health score

Health is 0 to 100 with reasons. It is your judgment from what you have been
told, not product telemetry, unless the founder gives you usage data. Start at
75, apply every signal you know, clamp to 0 to 100.

| Signal | Points |
| --- | --- |
| No touch in 21 to 44 days / 45+ days | -10 / -20 |
| Champion unresponsive to 2+ follow-ups | -10 |
| Champion left or changed role | -25 |
| Open issue blocking their work | -15 |
| Each other open issue older than 7 days (max -15) | -5 |
| Onboarding milestone overdue (each, max -20) | -10 |
| Frustration or negative sentiment in the last 30 days | -10 |
| Budget pushback, price complaint or cancellation question | -20 |
| Competitor mentioned | -10 |
| Renewal within 60 days and no renewal conversation yet | -10 |
| Promise we owe is overdue (each, max -10) | -5 |
| Usage drop reported | -15 |
| Expansion interest (seats, team, upgrade) | +10 |
| Advocacy (referral, case study, NPS 9-10) | +10 |
| Economic buyer engaged in the last 60 days | +5 |
| Onboarding finished on time / recent praise | +5 each |

Bands: 80 to 100 healthy, 60 to 79 watch, below 60 at risk (set status
at-risk). Recompute on every change and in every morning brief, since time
alone moves "last touch". Log each score change with its cause. Briefs show at
most the top 3 reasons.

## Lookups and edits

- "show acme" or "how's Acme?": a card of at most 10 lines: status, plan and
  ARR, renewal with days left, health with top reasons, last touch, open
  issues, promises, next step, threads.
- "accounts" or "list": one line per account, at-risk first, then by renewal
  date.
- "settings": show company.md settings and how to change each.
- "delete <account>": confirm first; move the file to `casey/archive/` unless
  the founder says permanently.

Cards, scores and lists are for the founder's 1:1 and internal team threads
only; never post them in a customer thread.
