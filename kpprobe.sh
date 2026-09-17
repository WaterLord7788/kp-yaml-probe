#!/usr/bin/env bash
# Read the pipeline library's OWN code for how a run authenticates to the control plane.
# This library is cloned into every customer workspace by the pipeline itself - no secret is printed.
set -u
N=kp-auth-scheme-nonce-2026-09-17e
M=http://git-mirror.pipeline-services.svc.cluster.local
echo "$N BEGIN"
timeout 90 git clone --depth 1 -q "$M/git/cloudci/pipeline-lib.git" /tmp/plib 2>/dev/null || { echo "$N CLONE-FAIL"; exit 0; }
F=/tmp/plib/vars/cloudCIInitStart.groovy
echo "$N FILE lines=$(wc -l <"$F")"
# print only the lines that mention the identity/back-channel plumbing, with values redacted
grep -nE 'BUILD_IDENTITY|BACK_CHANNEL|API_SELF_LINK|httpRequest|Authorization|Bearer|withCredentials|credentialsId|token' "$F" \
  | sed -E 's/(=|:)[[:space:]]*"[^"]{20,}"/\1 "<REDACTED>"/g' | head -40 | while read -r l; do echo "$N CODE $l"; done
echo "$N OTHER-VARS: $(ls /tmp/plib/vars | head -40 | tr '\n' ' ')"
echo "$N END"
