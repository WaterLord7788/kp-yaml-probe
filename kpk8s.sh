#!/bin/sh
M=http://git-mirror.pipeline-services.svc.cluster.local
echo "KPMIR-START-7788"
echo "--- service root ---"
curl -s -m 15 -o /tmp/r0 -w "root: %{http_code} %{size_download} %{content_type}\n" "$M/" 2>&1
head -c 400 /tmp/r0; echo ""
curl -s -m 15 -o /tmp/r1 -w "/git/: %{http_code} %{size_download} %{content_type}\n" "$M/git/" 2>&1
head -c 400 /tmp/r1; echo ""
echo "--- known-good path (the one the service itself discloses) ---"
curl -s -m 15 -o /dev/null -w "cloudci/pipeline-lib: %{http_code}\n" "$M/git/cloudci/pipeline-lib.git/info/refs?service=git-upload-pack"
echo "--- is the PUSH service open? (no push performed) ---"
curl -s -m 15 -o /dev/null -w "receive-pack advert: %{http_code}\n" "$M/git/cloudci/pipeline-lib.git/info/refs?service=git-receive-pack"
echo "--- is MY OWN github repo mirrored here? (only my own paths probed) ---"
for p in kp-yaml-probe WaterLord7788/kp-yaml-probe github.com/WaterLord7788/kp-yaml-probe cloudci/kp-yaml-probe; do
  echo "  $p -> $(curl -s -m 15 -o /dev/null -w '%{http_code}' "$M/git/$p.git/info/refs?service=git-upload-pack")"
done
echo "--- what other SAP paths does it answer? (non-customer names only) ---"
for p in cloudci/piper-lib-os piper-lib-os cloudci/pipeline-lib-test cloudci/does-not-exist-7788; do
  echo "  $p -> $(curl -s -m 15 -o /dev/null -w '%{http_code}' "$M/git/$p.git/info/refs?service=git-upload-pack")"
done
echo "KPMIR-END-7788"
