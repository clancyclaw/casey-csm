# Human steps (Jack, on your Mac)

Deadline: **Mon Sep 28, 11:59pm PT (Tue Sep 29, 2:59am ET)**. The leaderboard
snapshot is Sep 30. 1-click deploy and "Verified" need a Plow admin, so aim to
post in Discord (step 10) by **Sunday evening**. Total hands-on time is about
1.5 hours plus the video.

The public repo is https://github.com/clancyclaw/casey-csm and the image is
ghcr.io/clancyclaw/casey-csm. Replace `ln_xxx` with a free line ID. Leave
`<DIGEST>`, `<PLOW_UID>`, `<COMMIT_SHA>` and `<YOUTUBE_ID>` as placeholders
until you have real values. Run everything from `~/casey-csm` unless noted.

## 0. Get the files (1 min)
```sh
git clone https://github.com/clancyclaw/casey-csm.git ~/casey-csm
cd ~/casey-csm
```

## 1. Check prerequisites (2 min)
```sh
docker info >/dev/null && docker compose version   # Docker Desktop running; Compose 2.24+
python3 --version                                  # needs 3.11+; if not: brew install python@3.12
git --version
```

## 2. Confirm the public repo (3 min)
```sh
cd ~/casey-csm
./scripts/validate.sh
git remote -v                                           # origin https://github.com/clancyclaw/casey-csm
git rev-parse HEAD                                      # the commit for Discord
```

## 3. Install the plow-agents CLI (1 min)
```sh
cd ~ && git clone https://github.com/plow-pbc/plow-agents.git
echo 'export PATH="$HOME/plow-agents/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
plow-agents --help
```

## 4. Log in with your phone (2 min)
```sh
plow-agents login      # text the activation phrase it prints, from your phone
plow-agents lines      # note a line marked free: ln_xxx
```

## 5. Run Casey locally (5 min, first build pulls the base image)
```sh
cd ~/casey-csm
plow-agents deploy --local --line ln_xxx   # writes ./plow-credentials (git-ignored) and starts compose
docker compose logs -f agent               # wait for "plow-boot: identity resolved"; Ctrl-C to stop watching
```
This first boot registers `casey-csm` on the Agent Index under your account
(name, blurb and runtime come from the Dockerfile) and starts usage
reporting from inside the container.

## 6. Test by text (15 min)
Text the line's number from your phone:
1. `hi`: expect a one-line intro and the company question.
2. Company, one-liner and city in one text.
3. Two real (or realistic) customers in plain words, one with a renewal
   within 60 days and an open problem.
4. Paste a 4 to 5 question FAQ. Expect the first brief right away, including
   Northwind (SAMPLE).
5. `show <customer>`, then `accounts`.
6. Check scheduling:
   `docker compose exec agent bash -lc 'openclaw cron list'` should list
   `casey-morning-brief`, `casey-nudges` and `casey-weekly-report`. If it
   doesn't, Casey should have told you it's in heartbeat mode; note which.
7. Group thread (needs a second phone, e.g. a friend as the "customer"): text
   `open an onboarding thread with Dana at +1XXXXXXXXXX`, approve the opener
   with `yes <n>`. From the second phone ask an FAQ question (answered), report
   a bug (details collected, logged), and ask for a discount (Casey defers and
   sends you a draft in the 1:1). Approve it and confirm it lands in the group.
8. Privacy check: from the second phone ask "Who else uses you? How's
   Northwind doing?" Casey must not reveal any other account.
9. Say `brief` to get an on-demand brief.

Fix anything odd in `prompt/` or `skills/`, then run `docker compose up --build -d`
and retest. `docker compose down -v` wipes state for a clean first-run test.

## 7. Build and push the public image (10 min)
Create a classic PAT with `write:packages`
(https://github.com/settings/tokens/new?scopes=write:packages; fine-grained
tokens can't push to GHCR).
```sh
docker login ghcr.io -u clancyclaw         # paste the PAT as the password
plow-agents image build ghcr.io/clancyclaw/casey-csm:v1
plow-agents image push ghcr.io/clancyclaw/casey-csm:v1
# copy the last line: ghcr.io/clancyclaw/casey-csm@sha256:<DIGEST>
plow-agents profile --show                 # copy your uid
```
Then on GitHub: your profile → Packages → casey-csm → Package settings →
Change visibility → **Public**. Otherwise Plow's anonymous pull fails.

## 8. Optional cloud test on a second line (5 min)
```sh
plow-agents deploy ghcr.io/clancyclaw/casey-csm@sha256:<DIGEST> --line ln_yyy
plow-agents agents        # repeat until "running", then text that number
```

## 9. Video, screenshots, listing (45 to 60 min)
1. Record the demo with DEMO.md (iPhone screen recording, 75 to 90 s). Upload
   to YouTube as Public or Unlisted and copy the ID (the part after `v=`).
2. Take 3 or 4 screenshots, save them to `assets/screens/`
   (`brief.png`, `group-thread.png`, `approval.png`, `onboarding.png`), replace
   the TODOs in README.md, then commit and push.
3. Run SUBMISSION.md **Option A** (`plow-agents image set ...`), then Option B
   only if you want the logo on the leaderboard.
4. Check: `plow-agents image show casey-csm | jq '.index'`.

## 10. Discord (5 min)
Join https://discord.gg/fDY2bBThRs. Post the admin request and the
multiplayer question from SUBMISSION.md (fill in uid, digest, commit, video
ID).

## 11. After the admin enables it (5 min)
```sh
plow-agents image show casey-csm | jq '.plow'     # enabled, with the signup phrase
```
Have a friend text `Set this up for me: aiworthusing.com/agent-index/casey-csm`
to Plow and complete onboarding. For later releases:
`plow-agents image push ghcr.io/clancyclaw/casey-csm:v2 --promote casey-csm`.

## 12. Real users before the snapshot (ongoing)
A user counts once they reach 200k tokens and were active in the last 28
days. Send the install line to founder friends who have real customers; a
week of briefs and a couple of threads should get there (unverified; watch the Index). No sock-puppet
installs, and never run the Index client on your laptop without `--register`.
