#!/bin/sh
echo "KPCENSUS2-START-7788"
command -v git >/dev/null || { echo "NO-GIT"; exit 0; }
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | tail -2
[ -d /tmp/kplib ] || { echo "CLONE-FAILED"; exit 0; }
cd /tmp/kplib || exit 0
echo "KPCENSUS2-HEAD=$(git rev-parse HEAD 2>/dev/null)"
echo "KPCENSUS2-TAG=$(git describe --tags 2>/dev/null)"
echo "--- tree ---"
find . -path ./.git -prune -o -type f -print 2>/dev/null | sed 's|^\./||' | sort | head -80
echo "--- shell sinks with interpolation ---"
grep -rnE '(sh|bat)[[:space:]]*\(?[[:space:]]*(script:)?[[:space:]]*"[^"]*\$\{' vars src resources 2>/dev/null | head -40
echo "--- dynamic groovy / template sinks ---"
grep -rnE 'createTemplate|GroovyShell|Eval\.|[^a-zA-Z]evaluate\(|new GroovyScriptEngine|Class\.forName' vars src resources 2>/dev/null | head -25
echo "--- reads of workspace-controlled files ---"
grep -rnE 'readYaml|readJSON|readFile|libraryResource|readTrusted' vars src resources 2>/dev/null | head -30
echo "--- credential handling ---"
grep -rnE 'withCredentials|credentialsId|usernamePassword\(|string\(cred' vars src resources 2>/dev/null | head -40
echo "KPCENSUS2-END-7788"
