#!/bin/sh
echo "KPC9-START-7788"
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib && git checkout -q v4.25.1
echo "KPC9-AT=$(git describe --tags)"
for f in src/com/sap/cloudci/PipelineConstants.groovy src/com/sap/cloudci/EnvironmentUtils.groovy vars/cloudCIPrepareConnectivity.groovy; do
  echo "===== KPC9-FILE $f ====="; cat "$f"
done
echo "===== KPC9-FILE Utils.groovy (proxy/plumbing part) ====="
sed -n '95,200p' src/com/sap/cloudci/Utils.groovy
echo "===== KPC9-MALWARE-PROXY reachability (read-only) ====="
P=http://sap-btp-malware-scanner-proxy.pipeline-services.svc.cluster.local
curl -s -m 15 -o /tmp/m0 -w "GET / : %{http_code} %{size_download} %{content_type}\n" "$P/" 2>&1; head -c 300 /tmp/m0; echo ""
curl -s -m 15 -o /dev/null -w "GET /info : %{http_code}\n" "$P/info" 2>&1
curl -s -m 15 -D /tmp/mh -o /dev/null -w "HEAD-ish / : %{http_code}\n" "$P/" 2>&1; head -c 400 /tmp/mh; echo ""
echo "KPC9-END-7788"
