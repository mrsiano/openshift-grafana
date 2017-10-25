#!/bin/bash

DEPLOY=$1
if [ "$DEPLOY" == "deploy" ]
then
    oc new-app -f prometheus-high-performance.yaml
    exit 0
fi

oc project kube-system
oc get all --all-namespaces|egrep 'prom|alert'|awk '{print $2}'|grep [a-z]|xargs oc delete
oc get configmaps|grep prom|awk '{print $1}' | xargs oc delete configmaps
oc get secrets|egrep 'prom|alert'|awk '{print $1}' | xargs oc delete secrets
oc delete sa prometheus
oc delete clusterrolebindings prometheus-cluster-reader
oc new-app -f prometheus-high-performance.yaml

exit 0