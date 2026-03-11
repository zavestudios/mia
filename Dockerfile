# Mia - OpenClaw AI Gateway
# Use the official OpenClaw runtime image and layer workload defaults.
FROM ghcr.io/openclaw/openclaw:v2026.3.8@sha256:7b1294f6aa2eb05b2070cc614743f79212313fc294e5de221ada8a2969ea52f6
ENV HOME=/home/node

USER root
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw
COPY --chown=node:node config/openclaw.json /home/node/.openclaw/openclaw.json

EXPOSE 18789
USER node
