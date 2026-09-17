#!/usr/bin/env bash
# Read-only identity probe of the build container. No writes, no escape attempt.
echo "KPIDENT-7788-BEGIN"
id
echo "KPIDENT-7788-UID=$(id -u) GID=$(id -g)"
grep -E '^(Uid|Gid|CapEff|CapPrm|NoNewPrivs|Seccomp):' /proc/self/status
echo "KPIDENT-7788-END"
