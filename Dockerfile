FROM public.ecr.aws/e1h7x4a2/plow-cloud-agents:base-7ce757a1745de286dd180c5c5182aca31eba8a75@sha256:6e5e1a11a8c6e2ef6ecaa5e7b429e778a9a3befaf416a09922aaaa4a5b21d647
ARG PLOW_REVISION
LABEL org.opencontainers.image.revision=$PLOW_REVISION
ENV AGENT_ID=casey-csm AGENT_NAME="Casey: First Customer Success Hire" AGENT_BLURB="Your first customer success hire: tracks every account, briefs you each morning on who needs you, and works your customer group texts." AGENT_RUNTIME=OpenClaw
COPY prompt/AGENTS.md /opt/plow/prompt/AGENTS.md
COPY skills/ /opt/plow/skills/
