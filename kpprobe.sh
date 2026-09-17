#!/usr/bin/env bash
# Which steps does the HOSTED pipeline actually run, and does repo config reach them?
# Reads the library that is already cloned into this workspace by the pipeline itself.
set -u
N=kp-libmap-nonce-2026-09-17f
M=http://git-mirror.pipeline-services.svc.cluster.local
timeout 90 git clone --depth 1 -q "$M/git/cloudci/pipeline-lib.git" /tmp/plib 2>/dev/null || { echo "$N CLONE-FAIL"; exit 0; }
cd /tmp/plib
echo "$N BEGIN"
for s in slackSendNotification piperPublishWarnings artifactSetVersion spinnakerTriggerPipeline mailSendNotification setupCommonPipelineEnvironment; do
  echo "$N USES $s -> $(grep -rl "$s" vars src resources 2>/dev/null | head -3 | tr '\n' ' ')"
done
echo "$N CONFIG-FLAGS: $(grep -rnoE 'DISABLE_EXTENSIONS|ignoreCustomDefaults|configurationSource|customDefaults' vars src resources 2>/dev/null | head -12 | tr '\n' ' ' | head -c 600)"
echo "$N VARS-COUNT: $(ls vars | wc -l)"
echo "$N VARS: $(ls vars | tr '\n' ' ' | head -c 900)"
echo "$N END"
