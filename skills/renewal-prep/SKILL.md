---
name: renewal-prep
description: Renewal prep packs (automatically at 90, 60 and 30 days before renewal, or on "prep <account>"), QBR drafts ("qbr <account>" or 14 days before a scheduled review), and churn-risk plays matched to specific warning signals. Use when a renewal window opens, health drops into watch or at-risk, a churn signal appears, or the founder asks how to save, renew or expand an account.
---
# Renewals, QBRs and churn-risk plays

Renewals are where a first CS hire pays for itself. Everything here is built
from the account file, its log and thread summaries. Mark unknowns instead of
filling them, and never propose a price, discount or term yourself: lay out
options and let the founder choose.

## Renewal prep pack

Triggers: renewal 90, 60 or 30 days out (once each; record it in
`casey/schedule.md`), or "prep <account>". At 90 days send a short heads-up
with the 3 things to do now; at 60 days send the full pack; at 30 days send
the pack plus a day-by-day plan to signature.

Pack format (founder's 1:1; phone-readable; about 25 lines):

```
Renewal pack · Acme Robotics · $24k ARR · renews Nov 12 (60d) · auto-renew no, 30d notice
Read: likely renew, at risk on SSO. Health 58 (watch).
Value delivered: <2-3 outcomes from the log, with dates; "?" if none recorded>
Risks: <top 3 with evidence: "ACME-3 SSO bug open 9 days", "Dana silent 12 days">
People: Dana Ruiz (champion, engaged) · Marco Li (VP Ops, economic buyer, last touch Jul 2) · Priya (IT, blocker on SSO)
Their goals next year: <from notes or "? ask Dana">
Expansion angle: <seats, teams, plan, only if there is evidence>
Options for you: (a) renew flat; (b) multi-year at current price; (c) <other>. Your call on any concession.
Plan:
- this week: fix or give a date on ACME-3 (Priya)
- next week: exec check-in with Marco (draft A-21 ready)
- day 45: renewal proposal email (I'll draft once you pick an option)
Questions to ask: <3 sharp discovery questions>
```

Queue the drafts the plan needs (exec check-in, renewal email) through the
approvals skill, and say which ones are waiting.

## QBR draft

Triggers: "qbr <account>", or an Upcoming QBR date within 14 days. Produce an
outline the founder can paste into slides or an email:

1. Their goals this quarter (from notes; `?` if never stated).
2. What we delivered: shipped features they asked for, issues fixed, time to
   resolve, onboarding milestones.
3. Adoption and outcomes: only figures the founder or customer gave you;
   otherwise a "bring these numbers" list.
4. Support summary: issues opened and closed, anything still open.
5. What we heard: requests and feedback, verbatim where you have it.
6. Next quarter: 3 proposed goals and owners on both sides.
7. Asks: referral, case study, expansion, exec intro, only where health
   supports it.

Offer to draft the invite or recap for the champion as an approval item.

## Churn-risk plays

When a signal fires, recommend the matching play in the brief (or right away
if urgent), with the first step drafted. One play per account at a time;
record it under Next step.

| Signal | Play | First step you prepare |
| --- | --- | --- |
| Champion silent 14+ days | Re-engage lightly, then multi-thread | Short check-in with a useful update; ask the founder for a second contact |
| Champion left or changed role | Rebuild the map | Warm note to the successor or economic buyer, and a note of thanks to the old champion |
| Blocking issue open 7+ days | Own the fix visibly | Status update draft with what the team is doing; ask the owning teammate for an honest ETA |
| Onboarding milestone overdue | Working session | Invite to a 30-minute session with the teammate who owns onboarding |
| Low or dropping usage reported | Value reset | Ask what changed; offer a training session for the new users |
| Budget or price pushback | Value recap before any concession | Value recap for the founder; options listed, concessions are the founder's call |
| Competitor mentioned | Founder call | Brief the founder on what was said; suggest a call this week |
| Frustration in a thread | Calm acknowledgment plus a personal touch | Founder-signed note or call suggestion; never argue |
| Renewal within 30 days, no reply | Escalate the relationship | Founder-to-exec note draft, sent from the founder's account only with approval |

Everything customer-facing in these plays goes through approvals. Track the
outcome in the log so next quarter's plays get better.
