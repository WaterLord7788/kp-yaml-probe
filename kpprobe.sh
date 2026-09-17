#!/usr/bin/env bash
# Bounded READ-ONLY reachability probe of the in-cluster git mirror, from my OWN build pod.
# Ref names and status codes only - no clone, no content, nothing exfiltrated.
set -u
N=kp-mirror-probe-nonce-2026-09-17c
M=http://git-mirror.pipeline-services.svc.cluster.local
echo "$N BEGIN"
http(){ out=$(curl -s -o /tmp/kpm.out -w '%{http_code} %{size_download}' --max-time 15 "$2" 2>/dev/null)
        echo "$N HTTP $1 -> $out :: $(head -c 150 /tmp/kpm.out | tr -d '\n')"; }
lsr(){ if timeout 20 git ls-remote --heads "$2" >/tmp/kpl.out 2>/tmp/kpl.err; then
         echo "$N LSR  $1 -> OK refs=$(wc -l </tmp/kpl.out) :: $(head -c 120 /tmp/kpl.out | tr -d '\n')"
       else echo "$N LSR  $1 -> FAIL :: $(head -c 150 /tmp/kpl.err | tr -d '\n')"; fi; }
# POSITIVE CONTROL: the repo the pipeline itself clones from the mirror.
lsr  "control-pipeline-lib" "$M/git/cloudci/pipeline-lib.git"
# NEGATIVE CONTROL: a repo that cannot exist.
lsr  "control-nonexistent"  "$M/git/cloudci/kp-no-such-repo-7788.git"
http "root"        "$M/"
http "git-root"    "$M/git/"
http "cloudci-dir" "$M/git/cloudci/"
http "inforefs"    "$M/git/cloudci/pipeline-lib.git/info/refs?service=git-upload-pack"
# Is any TENANT repository mirrored here? (my own tenant/job/repo names)
lsr  "tenant-own-repo" "$M/git/kpyamlprobe.git"
lsr  "cloudci-lib"     "$M/git/cloudci/cloudci-lib.git"
echo "$N END"
