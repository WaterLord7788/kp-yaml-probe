// Benign extension-execution probe for an authorized bug-bounty test.
// Does nothing but echo a unique marker, then runs the original stage unchanged.
def call(Map parameters) {
  echo "KPEXT_EXECUTED_NONCE_7788 stage=${parameters.stageName}"
  parameters.originalStage()
}
return this
