#!/bin/sh
M=http://sap-btp-malware-scanner-proxy.pipeline-services.svc.cluster.local
B=http://pipeline-utils-blobstore-proxy.pipeline-services.svc.cluster.local
T=$B/artifacts_1.0/pipeline-telemetry/1.0.3/pipeline-telemetry
echo "KPCA-START-7788"
echo "--- malware scanner proxy: /info (200 unauth per build 100) ---"
curl -s -m 15 -o /tmp/a1 -w "  GET /info : %{http_code} %{size_download} %{content_type}\n" "$M/info"; head -c 500 /tmp/a1; echo ""
for p in / /health /metrics /scan /v1 /api; do
  printf '  GET %-10s %s\n' "$p" "$(curl -s -m 15 -o /dev/null -w '%{http_code}' "$M$p")"
done
echo "--- blobstore proxy: the telemetry executable every managed build downloads ---"
curl -s -m 25 -o /tmp/a2 -D /tmp/a2h -w "  GET telemetry : %{http_code} %{size_download} %{content_type}\n" "$T"
grep -iE '^(server|etag|last-modified|x-|content-type|accept-ranges)' /tmp/a2h | head -12
echo "  sha256=$(sha256sum /tmp/a2 | cut -c1-32)  file=$(head -c 4 /tmp/a2 | od -An -c | tr -s ' ')"
echo "--- blobstore: listing? ---"
for p in / /artifacts_1.0/ /artifacts_1.0/pipeline-telemetry/ /artifacts_1.0/pipeline-telemetry/1.0.3/; do
  printf '  GET %-44s %s\n' "$p" "$(curl -s -m 15 -o /dev/null -w '%{http_code} %{size_download}' "$B$p")"
done
echo "--- blobstore WRITE AUTHORIZATION, probed only on targets a write CANNOT land on ---"
echo "    (no object path is ever sent: '/' and a directory path, so a 2xx is impossible)"
for m in PUT POST DELETE; do
  printf '  %-6s /                                     %s\n' "$m" "$(curl -s -m 15 -X $m -o /dev/null -w '%{http_code}' "$B/")"
  printf '  %-6s /artifacts_1.0/                       %s\n' "$m" "$(curl -s -m 15 -X $m -o /dev/null -w '%{http_code}' "$B/artifacts_1.0/")"
done
printf '  OPTIONS telemetry -> %s\n' "$(curl -s -m 15 -X OPTIONS -D /tmp/a3h -o /dev/null -w '%{http_code}' "$T")"
grep -iE '^(allow|access-control-allow-methods)' /tmp/a3h
echo "--- my own build config as handed to customer code ---"
echo "  SAPCID_BUILD_CONFIG_JSON=$SAPCID_BUILD_CONFIG_JSON"
echo "KPCA-END-7788"
