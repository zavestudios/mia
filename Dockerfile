# Autonomous Agent - OpenClaw runtime
# Use the official OpenClaw runtime image and layer platform-service defaults.
FROM ghcr.io/openclaw/openclaw:2026.5.22@sha256:dcfd148777401d1bbdc63eab5c2f280bbfa912dfb1818566f9d66bb96ffb3f95
ENV HOME=/home/node

USER root
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw

COPY config/openclaw.json /home/node/.openclaw/openclaw.json
RUN chown node:node /home/node/.openclaw/openclaw.json

USER node

EXPOSE 18789
