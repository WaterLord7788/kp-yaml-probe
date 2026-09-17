#!/usr/bin/env bash
# How does a run obtain credential instances, and is the job's credential binding the gate?
set -u
N=kp-credpath-nonce-2026-09-17g
M=http://git-mirror.pipeline-services.svc.cluster.local
timeout 90 git clone --depth 1 -q "$M/git/cloudci/pipeline-lib.git" /tmp/plib 2>/dev/null || { echo "$N CLONE-FAIL"; exit 0; }
cd /tmp/plib
F=vars/cloudCIGetCredentialInstance.groovy
echo "$N BEGIN file_lines=$(wc -l <"$F" 2>/dev/null)"
sed -E 's/(=|:)[[:space:]]*"[^"]{24,}"/\1 "<REDACTED>"/g' "$F" | head -70 | nl -ba | while read -r l; do echo "$N SRC $l"; done
echo "$N CALLERS: $(grep -rl 'cloudCIGetCredentialInstance' vars src resources 2>/dev/null | tr '\n' ' ')"
echo "$N END"
