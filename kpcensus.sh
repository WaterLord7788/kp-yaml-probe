#!/bin/sh
echo "KPCB-START-7788"
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib && git checkout -q v4.25.1
echo "KPCB-AT=$(git describe --tags) HEAD=$(git rev-parse HEAD)"
tar czf /tmp/kplib.tgz vars src resources 2>/dev/null
echo "KPCB-BYTES=$(wc -c < /tmp/kplib.tgz)  SHA=$(sha256sum /tmp/kplib.tgz | cut -c1-32)"
echo "KPCB-B64-BEGIN"
base64 -w 200 /tmp/kplib.tgz
echo "KPCB-B64-END"
echo "KPCB-END-7788"
