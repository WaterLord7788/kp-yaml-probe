#!/usr/bin/env bash
# Bounded, benign probe run inside my OWN build pod. Never prints the token value.
# Goal: find the scheme that authenticates the run's OWN back-channel (positive control FIRST).
set -u
N=kp-cp-probe-nonce-2026-09-17b
T="${BUILD_IDENTITY_JWT:-}"
SELF="${API_SELF_LINK:-}"
BC="${BACK_CHANNEL_URL:-}"
BUILD_UUID="${SELF##*/}"
JOB_ID=$(printf '%s' "$SELF" | sed -n 's#.*/v2/jobs/\([^/]*\)/builds/.*#\1#p')
echo "$N BEGIN build_uuid=$BUILD_UUID job_id=$JOB_ID"
try(){ # label  curl-args...
  local label="$1"; shift
  out=$(curl -s -o /tmp/kpb.out -w '%{http_code} %{size_download}' --max-time 20 "$@" 2>/dev/null)
  echo "$N $label -> $out :: $(head -c 200 /tmp/kpb.out | tr -d '\n')"
}
try "self:basic-uuid"    -u "$BUILD_UUID:$T"           "$SELF"
try "self:basic-jobid"   -u "$JOB_ID:$T"               "$SELF"
try "self:basic-empty"   -u ":$T"                      "$SELF"
try "self:basic-build"   -u "build:$T"                 "$SELF"
try "self:basic-tokuser" -u "$T:"                      "$SELF"
try "self:hdr-identity"  -H "X-Build-Identity: $T"     "$SELF"
try "self:hdr-jwt"       -H "Build-Identity-Jwt: $T"   "$SELF"
try "bc:basic-uuid"      -u "$BUILD_UUID:$T"           "$BC"
echo "$N END"
