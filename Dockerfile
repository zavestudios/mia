# Mia - Containerized OpenClaw AI Gateway
# Node.js 22+ base image
FROM node:22-slim

WORKDIR /app

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create OpenClaw config directory
RUN mkdir -p /root/.openclaw

# Copy configuration file (if exists)
COPY config/openclaw.json /root/.openclaw/openclaw.json 2>/dev/null || true

# Expose OpenClaw gateway port
EXPOSE 18789

# Health check for OpenClaw gateway
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD node -e "require('http').get('http://localhost:18789/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

# Run OpenClaw gateway
CMD ["openclaw", "gateway", "--port", "18789"]
