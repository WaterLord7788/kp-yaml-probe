#!/bin/sh
echo "KPC3-START-7788"
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib || { echo "KPC3-CLONE-FAILED"; exit 0; }
echo "KPC3-HEAD=$(git rev-parse HEAD) TAG=$(git describe --tags 2>/dev/null)"
echo "--- sizes ---"
wc -l Jenkinsfile ReleaseJenkinsfile resources/scripts/*.sh vars/*.groovy src/com/sap/cloudci/*.groovy 2>/dev/null
for f in resources/scripts/checkCommitToBeBuiltIsReachable.sh vars/cloudCICheckout.groovy vars/cloudCIInitStart.groovy vars/cloudCIAfterAllStages.groovy src/com/sap/cloudci/AfterAllStagesUtils.groovy; do
  echo "===== KPC3-FILE $f ====="
  cat "$f"
done
echo "KPC3-END-7788"
