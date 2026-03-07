# Mia - OpenClaw AI Gateway
# Use the official OpenClaw runtime image and layer workload defaults.
FROM ghcr.io/openclaw/openclaw:latest
ENV HOME=/home/node

USER root
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw
COPY --chown=node:node config/openclaw.json /home/node/.openclaw/openclaw.json

EXPOSE 18789
USER node
