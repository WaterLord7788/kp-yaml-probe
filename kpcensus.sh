#!/bin/sh
echo "KPCENSUS-START-7788"
L=$(ls -d /jenkins_home/workspace/*@libs/*/vars 2>/dev/null | head -1)
if [ -z "$L" ]; then L=$(find / -maxdepth 8 -type d -name vars -path '*@libs*' 2>/dev/null | head -1); fi
echo "KPCENSUS-LIBVARS=$L"
R=$(dirname "$L")
echo "KPCENSUS-ROOT=$R"
echo "--- files ---"
find "$R" -maxdepth 2 -type f \( -name '*.groovy' -o -name '*.yml' -o -name '*.yaml' \) 2>/dev/null | sed "s|$R/||" | sort
echo "--- shell sinks with interpolation ---"
grep -rnE '(sh|bat)[[:space:]]*\(?[[:space:]]*(script:)?[[:space:]]*"[^"]*\$\{' "$R" 2>/dev/null | head -40
echo "--- dynamic groovy / template sinks ---"
grep -rnE 'createTemplate|GroovyShell|Eval\.|evaluate\(|\.toGString|new GroovyScriptEngine' "$R" 2>/dev/null | head -25
echo "--- readYaml/readJSON/load from workspace ---"
grep -rnE 'readYaml|readJSON|readFile|load[[:space:]]+' "$R" 2>/dev/null | head -25
echo "--- credential handling ---"
grep -rnE 'withCredentials|credentialsId|usernamePassword|string\(cred' "$R" 2>/dev/null | head -30
echo "KPCENSUS-END-7788"
