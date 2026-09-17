#!/bin/sh
echo "KPC5-START-7788"
echo "KPC5-BUILD_IDENTITY_JWT_ID=[$BUILD_IDENTITY_JWT]"
echo "KPC5-GIT_CREDENTIAL_ID=[$GIT_CREDENTIAL_ID]"
echo "KPC5-GIT_CC_CREDENTIAL_ID=[$GIT_CLOUDCONNECTOR_CREDENTIAL_ID]"
echo "KPC5-BACK_CHANNEL_URL=[$BACK_CHANNEL_URL]"
echo "KPC5-API_SELF_LINK=[$API_SELF_LINK]"
rm -rf /tmp/kplib
git clone -q http://git-mirror.pipeline-services.svc.cluster.local/git/cloudci/pipeline-lib.git /tmp/kplib 2>&1 | head -3
cd /tmp/kplib || { echo "KPC5-CLONE-FAILED"; exit 0; }
echo "--- DEPLOYED TAG v4.25.1: does the same lookup exist there? ---"
git show v4.25.1:src/com/sap/cloudci/SharedConfigurationUtils.groovy 2>&1 | grep -n -B14 -A6 'lookupCredentials'
echo "--- diff v4.25.1..HEAD for the credential file ---"
git diff --stat v4.25.1..HEAD -- src/com/sap/cloudci/SharedConfigurationUtils.groovy vars/cloudCIAfterAllStages.groovy
echo "--- cloudCIGetCredentialInstance @ v4.25.1 ---"
git show v4.25.1:vars/cloudCIGetCredentialInstance.groovy 2>&1 | head -40
echo "KPC5-END-7788"
