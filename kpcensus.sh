#!/bin/sh
echo "KPC6-START-7788"
echo "KPC6-THIS-BUILD=$SAPCID_BUILD_ID"
echo "KPC6-TARGET-ID=build-id-jwt-ed5f0c7e-375b-4ad6-b523-4065c5b06e56 (identity credential of build 92)"
if [ -n "$KPJWT" ]; then
  echo "KPC6-BOUND=YES"
  echo "KPC6-LEN=$(printf %s "$KPJWT" | wc -c)"
  echo "KPC6-DOTS=$(printf %s "$KPJWT" | tr -cd '.' | wc -c)"
  echo "KPC6-SHA256-16=$(printf %s "$KPJWT" | sha256sum | cut -c1-16)"
  echo "KPC6-HEAD2=$(printf %s "$KPJWT" | cut -c1-2)"
else
  echo "KPC6-BOUND=NO"
fi
echo "KPC6-END-7788"
