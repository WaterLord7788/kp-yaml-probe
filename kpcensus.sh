#!/bin/sh
echo "KPC7-START-7788"
echo "KPC7-THIS-BUILD=$SAPCID_BUILD_ID"
echo "KPC7-TARGET-ID=kp-cred1 = a tenant secretText NOT bound to this job"
if [ -n "$KPJWT" ]; then
  echo "KPC7-BOUND=YES"
  echo "KPC7-LEN=$(printf %s "$KPJWT" | wc -c)"
  echo "KPC7-DOTS=$(printf %s "$KPJWT" | tr -cd '.' | wc -c)"
  echo "KPC7-SHA256-16=$(printf %s "$KPJWT" | sha256sum | cut -c1-16)"
  echo "KPC7-HEAD2=$(printf %s "$KPJWT" | cut -c1-2)"
else
  echo "KPC7-BOUND=NO"
fi
echo "KPC7-END-7788"
