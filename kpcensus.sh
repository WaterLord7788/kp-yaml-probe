#!/bin/sh
echo "KPC4-START-7788"
echo "--- env NAMES only (no values: never extract a live credential) ---"
env | cut -d= -f1 | sort | tr '\n' ' '
echo ""
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib || { echo "KPC4-CLONE-FAILED"; exit 0; }
echo "KPC4-HEAD=$(git rev-parse HEAD)"
for f in vars/cloudCIInitStart.groovy vars/cloudCIAfterAllStages.groovy src/com/sap/cloudci/AfterAllStagesUtils.groovy src/com/sap/cloudci/SharedConfigurationUtils.groovy vars/cloudCIGetCredentialInstance.groovy; do
  echo "===== KPC4-FILE $f ====="
  cat "$f"
done
echo "KPC4-END-7788"
