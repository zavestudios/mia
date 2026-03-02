# Mia - OpenClaw AI Assistant
# Multi-stage build for minimal production image

FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Production stage
FROM python:3.12-slim

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /usr/local /usr/local

# Copy application code
COPY . .

# Make sure pip-installed scripts are usable
ENV PATH=/usr/local/bin:$PATH

# Run as non-root user
RUN useradd -m -u 1000 mia && \
    chown -R mia:mia /app
USER mia

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import sys; sys.exit(0)"

# Default command (override in deployment)
CMD ["python", "main.py"]
