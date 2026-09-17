#!/bin/sh
echo "KPC8-START-7788"
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib || { echo "KPC8-CLONE-FAILED"; exit 0; }
git checkout -q v4.25.1 2>&1 | head -2
echo "KPC8-AT=$(git describe --tags)"
for f in resources/baseDefaults.yaml vars/cloudCIExecuteInToolbox.groovy Jenkinsfile; do
  echo "===== KPC8-FILE $f ====="; cat "$f"
done
echo "KPC8-END-7788"
