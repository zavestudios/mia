# Mia - OpenClaw AI Gateway
# Use the official OpenClaw runtime image and layer workload defaults.
FROM ghcr.io/openclaw/openclaw:v2026.3.8@sha256:7b1294f6aa2eb05b2070cc614743f79212313fc294e5de221ada8a2969ea52f6
ENV HOME=/home/node

# Accept phone numbers as build arguments (default to empty arrays for local dev)
ARG WHATSAPP_ALLOW_FROM='[]'
ARG WHATSAPP_GROUP_ALLOW_FROM='[]'

USER root
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw \
    && chmod 700 /home/node/.openclaw

# Copy config with placeholder tokens, substitute with build args, install to final location
COPY config/openclaw.json /tmp/openclaw.json
RUN sed -e "s|\"{{WHATSAPP_ALLOW_FROM}}\"|${WHATSAPP_ALLOW_FROM}|g" \
        -e "s|\"{{WHATSAPP_GROUP_ALLOW_FROM}}\"|${WHATSAPP_GROUP_ALLOW_FROM}|g" \
        /tmp/openclaw.json > /home/node/.openclaw/openclaw.json \
    && chown node:node /home/node/.openclaw/openclaw.json \
    && rm /tmp/openclaw.json

EXPOSE 18789
USER node
