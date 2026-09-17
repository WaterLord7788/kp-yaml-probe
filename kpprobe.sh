#!/usr/bin/env bash
# READ-ONLY: does the in-cluster git mirror advertise the PUSH service to an unauthenticated build pod?
# This performs NO write: it only asks what the server advertises. No ref update, no pack, no push.
set -u
N=kp-recvpack-nonce-2026-09-17h
M=http://git-mirror.pipeline-services.svc.cluster.local
echo "$N BEGIN"
for R in cloudci/pipeline-lib.git cloudci/piper-library.git; do
  for S in git-upload-pack git-receive-pack; do
    C=$(timeout 25 curl -s -o /tmp/o.$$ -w '%{http_code}' "$M/git/$R/info/refs?service=$S" 2>/dev/null || echo TIMEOUT)
    echo "$N ADV $R $S -> http=$C bytes=$(wc -c </tmp/o.$$ 2>/dev/null) first=$(head -c 60 /tmp/o.$$ 2>/dev/null | tr -d '\0' | tr '\n' ' ')"
    echo "$N CAPS $R $S -> $(tr '\0' '\n' </tmp/o.$$ 2>/dev/null | head -2 | tr -d '\r' | cut -c1-200 | tr '\n' ' ')"
  done
done
echo "$N ROOT -> http=$(timeout 15 curl -s -o /dev/null -w '%{http_code}' "$M/" 2>/dev/null)"
echo "$N AUTHHDR -> $(timeout 15 curl -s -D- -o /dev/null "$M/git/cloudci/pipeline-lib.git/info/refs?service=git-receive-pack" 2>/dev/null | grep -i -E '^(HTTP|WWW-Authenticate|Server)' | tr -d '\r' | tr '\n' ' ')"
echo "$N END"
