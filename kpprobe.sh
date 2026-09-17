#!/usr/bin/env bash
# Bounded, benign control-plane reachability probe run inside my OWN build pod.
# NEVER prints the token value. Prints only HTTP status codes and byte counts.
set -u
N=kp-cp-probe-nonce-2026-09-17
echo "$N BEGIN"
echo "$N BACK_CHANNEL_URL=${BACK_CHANNEL_URL:-unset}"
echo "$N API_SELF_LINK=${API_SELF_LINK:-unset}"
echo "$N UI_SELF_LINK=${UI_SELF_LINK:-unset}"
echo "$N jwt_len=${#BUILD_IDENTITY_JWT} dots=$(printf '%s' "${BUILD_IDENTITY_JWT:-}" | tr -cd '.' | wc -c)"
probe(){ # method url label
  local code sz
  out=$(curl -s -o /tmp/kpb.out -w '%{http_code} %{size_download}' -X "$1" \
        -H "Authorization: Bearer ${BUILD_IDENTITY_JWT:-}" "$2" --max-time 20 2>/dev/null)
  echo "$N $3 AUTHED  $out  :: $(head -c 160 /tmp/kpb.out | tr -d '\n')"
  out=$(curl -s -o /tmp/kpb2.out -w '%{http_code} %{size_download}' -X "$1" "$2" --max-time 20 2>/dev/null)
  echo "$N $3 NOAUTH  $out  :: $(head -c 160 /tmp/kpb2.out | tr -d '\n')"
}
# 1) POSITIVE CONTROL first: the run's own back-channel base and self link.
probe GET "${BACK_CHANNEL_URL:-http://127.0.0.1:1}" "backchannel-base"
probe GET "${API_SELF_LINK:-http://127.0.0.1:1}" "api-self-link"
echo "$N END"
