#!/bin/sh
echo "KPK8S-START-7788"
echo "--- whoami ---"; id; echo "HOST=$HOSTNAME  POD_CONTAINER=$POD_CONTAINER"
echo "--- serviceaccount mount ---"
ls -la /var/run/secrets/kubernetes.io/serviceaccount/ 2>&1
NS=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null)
T=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null)
echo "KPK8S-NAMESPACE=[$NS]"
echo "KPK8S-TOKEN-LEN=$(printf %s "$T" | wc -c)  DOTS=$(printf %s "$T" | tr -cd '.' | wc -c)"
echo "KPK8S-APISERVER=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS"
if [ -z "$T" ]; then echo "KPK8S-NO-TOKEN"; echo "KPK8S-END-7788"; exit 0; fi
echo "--- SelfSubjectReview (who does the API server think I am) ---"
curl -sk -m 20 -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' \
  --data '{"kind":"SelfSubjectReview","apiVersion":"authentication.k8s.io/v1"}' \
  "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS/apis/authentication.k8s.io/v1/selfsubjectreviews" 2>&1 | head -c 1200
echo ""
echo "--- SelfSubjectRulesReview in my OWN namespace (read-only introspection) ---"
curl -sk -m 20 -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' \
  --data "{\"kind\":\"SelfSubjectRulesReview\",\"apiVersion\":\"authorization.k8s.io/v1\",\"spec\":{\"namespace\":\"$NS\"}}" \
  "https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS/apis/authorization.k8s.io/v1/selfsubjectrulesreviews" 2>&1 | head -c 4000
echo ""
echo "KPK8S-END-7788"
