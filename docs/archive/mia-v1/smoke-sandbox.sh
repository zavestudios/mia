#!/usr/bin/env bash
set -euo pipefail

NS="${NS:-mia}"
DEPLOY="${DEPLOY:-mia}"

echo "==> Pod status"
kubectl -n "${NS}" get pods -o wide

echo
echo "==> Gateway health"
kubectl -n "${NS}" exec "deploy/${DEPLOY}" -- openclaw gateway health --json

echo
echo "==> OpenClaw status"
kubectl -n "${NS}" exec "deploy/${DEPLOY}" -- openclaw status --json

echo
echo "==> Recent logs"
kubectl -n "${NS}" logs "deploy/${DEPLOY}" --tail=120

echo
echo "Smoke checks completed."
