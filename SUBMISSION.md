# Submission kit: Casey (casey-csm)

Everything to paste into the Agent Index and Discord. Replace every `<...>`
placeholder. Slug `casey-csm` was unused on the live Index
(`GET https://agent-index-server.vercel.app/v1/agents`, 92 listings) on
Sat Sep 26 2026, about 6:35pm ET. Re-check right before you register.

## Listing copy

- **Slug / AGENT_ID:** `casey-csm`
- **Name:** `Casey: First Customer Success Hire`
- **Blurb (134 chars):**
  `Your first customer success hire: tracks every account, briefs you each morning on who needs you, and works your customer group texts.`
- **Runtime:** `OpenClaw`
- **Repo:** `https://github.com/clancyclaw/casey-csm`
- **Install / tutorial link:** `https://github.com/clancyclaw/casey-csm#install`
- **Logo:** `assets/logo.png` (512x512, rendered from `assets/logo.svg`)
- **Screenshots:** `https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/<file>.png` (at least 1 is required for "ready")
- **Video:** YouTube ID only, e.g. `dQw4w9WgXcQ`, never a URL

**Longer pitch (for README, Discord and stories):**

> Casey is the customer success hire a seed-stage founder can't afford yet.
> Text it your customers (notes, a forwarded email or a CSV) and it keeps a
> living account book: contacts, plan, ARR, renewal date, open issues, promises
> owed both ways, and a health score with the reasons. Every weekday morning it
> texts you the one to three accounts that need you today, with the next move
> already drafted. It works inside your customer group texts with you, your
> teammates and the customer's champions: it answers how-to questions from your
> FAQ, routes bugs to the right engineer, and keeps a shared summary. Renewal
> packs arrive at 90, 60 and 30 days. Nothing a customer reads goes out
> without your "yes" in your 1:1, and one customer never sees another's data.

**Tags.** A listing has no tag field; the Index shows a `hackathon` value
(`openclaw` on every OpenClaw-runtime listing today; how it is assigned is
unconfirmed). Tags attach to stories, up to 3 each. Existing tags to reuse:
`Founder operations`, `Team`, `imessage`, `Morning digest`, plus a new
`openclaw` tag.

## Register the listing

The first boot with `AGENT_ID=casey-csm` (your local `plow-agents deploy
--local` run) already registers the slug under your Plow account with the
name, blurb and runtime from the Dockerfile. After that, fill in the rest.

**Option A (recommended): `plow-agents image set`.** Sets everything except
the logo, using your `plow-agents login` token (no client on your laptop):

```sh
plow-agents image set casey-csm \
  --name "Casey: First Customer Success Hire" \
  --blurb "Your first customer success hire: tracks every account, briefs you each morning on who needs you, and works your customer group texts." \
  --repo "https://github.com/clancyclaw/casey-csm" \
  --link "https://github.com/clancyclaw/casey-csm#install" \
  --screenshot "https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/brief.png" \
  --screenshot "https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/group-thread.png" \
  --screenshot "https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/approval.png" \
  --video '{"provider":"youtube","id":"<YOUTUBE_ID>","title":"Casey: your first customer success hire (demo)"}'
plow-agents image show casey-csm | jq '.index'
```

**Option B: `agent_index_client.py --register`, every field including the
logo.** Only `--register` uploads a logo. Run it once, from the repo root, with
the file pinned at the commit Plow's base uses. On a laptop, never run the
client without `--register`: a plain run reports your laptop's Claude Code or
Codex usage as Casey's, which looks like artificial usage.

```sh
curl -fsS -o agent_index_client.py \
  "https://raw.githubusercontent.com/plow-pbc/agent-index-client/edf196031803e204cdbcd81ce574e1f54fd75f65/standalone/agent_index_client.py"
echo "970caf7534cd7d3b71ffee8f1a576f9da4dc494a508e8ab1998ee2ce6f4a2ac4  agent_index_client.py" | shasum -a 256 -c -
export PLOW_AGENT_TOKEN="$(cat ~/.config/plow/token)"
python3 agent_index_client.py --register \
  --agent casey-csm \
  --name "Casey: First Customer Success Hire" \
  --blurb "Your first customer success hire: tracks every account, briefs you each morning on who needs you, and works your customer group texts." \
  --repo "https://github.com/clancyclaw/casey-csm" \
  --runtime OpenClaw \
  --video "<YOUTUBE_ID>" \
  --image "https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/brief.png" \
  --image "https://raw.githubusercontent.com/clancyclaw/casey-csm/main/assets/screens/group-thread.png" \
  --install-url "https://github.com/clancyclaw/casey-csm#install" \
  --logo ./assets/logo.png
rm agent_index_client.py
```

Updates after an admin enables 1-click deploy:
`plow-agents image push ghcr.io/clancyclaw/casey-csm:v2 --promote casey-csm`.

## Discord: request for 1-click deploy and verification

To danedelattre (DM, or the Agent Index / hackathon channel the admins use):

```
Hi Dane! I'm submitting Casey to the OpenClaw 2.0 hackathon: a startup's first Customer Success hire, built on the Plow OpenClaw base. Could you enable 1-click deploy and verify the listing?

• Plow uid: <PLOW_UID from `plow-agents profile --show`>
• Slug / Agent Index ID: casey-csm (https://aiworthusing.com/agent-index/casey-csm)
• Image: ghcr.io/clancyclaw/casey-csm@sha256:<DIGEST> (public)
• Base: public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-7ce757a1745de286dd180c5c5182aca31eba8a75@sha256:6e5e1a11a8c6e2ef6ecaa5e7b429e778a9a3befaf416a09922aaaa4a5b21d647
• Repo: https://github.com/clancyclaw/casey-csm (MIT)
• Commit: <COMMIT_SHA>
• Demo: https://youtu.be/<YOUTUBE_ID>

What it does: keeps an account book from texted notes, emails or CSVs; sends a weekday morning brief (who needs you, renewals in 30/60/90 days, stalled onboardings); works customer group threads with the founder, teammates and champions (FAQ answers, bug routing, shared summary); everything customer-facing is drafted and approved in the founder's 1:1.

Quick test: text it, answer the 3 onboarding questions (or say "demo"), then ask for "brief". <CONFIRM BEFORE SENDING: usage from my local test deploy shows on the Index.>

Also: could you make sure the listing shows under the OpenClaw hackathon board? Thanks!
```

## Discord: multiplayer question

```
Quick rules question for the OpenClaw 2.0 hackathon: does "multiplayer mode" count if the agent works in Plow group text threads (founder + teammates + customers, each group its own OpenClaw session), or do judges expect OpenClaw 2.0 native shared sessions in the Control UI? On Plow the dashboard is owner-only, so group texts are the realistic multiplayer surface. Casey (casey-csm) is built around group threads. Thanks!
```
