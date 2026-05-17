# Mia - OpenClaw AI Gateway
# Use the official OpenClaw runtime image and layer workload defaults.
FROM ghcr.io/openclaw/openclaw:2026.5.12@sha256:e2482a66682de6f540dcfd9921e410c23fd060dcd441382ff952247ee911a672
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

USER node

# Install the official WhatsApp plugin explicitly. In OpenClaw 2026.5.x the
# WhatsApp dependency cone is no longer part of the lean core runtime image.
RUN openclaw plugins install clawhub:@openclaw/whatsapp

EXPOSE 18789
