# Mia - OpenClaw AI Gateway
# Use the official OpenClaw runtime image and layer workload defaults.
FROM ghcr.io/openclaw/openclaw:v2026.3.7@sha256:70c5677580a958f704eb27297a62661b501534c3b2b9dec7a61e5ed5aa0c24cf
ENV HOME=/home/node

USER root
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw
COPY --chown=node:node config/openclaw.json /home/node/.openclaw/openclaw.json

EXPOSE 18789
USER node
