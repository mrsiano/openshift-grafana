#!/bin/bash

datasource_name=$1
prometheus_namespace=$2
oauth=$3
yaml="grafana-ocp.yaml"
protocol="http://"


usage() {
echo "
USAGE
 setup-grafana.sh pro-ocp openshift-metrics true

 args:
   datasource_name: grafana datasource name
   prometheus_namespace: existing prometheus name e.g openshift-metrics
   oauth: if set to true it will deploy grafana with oauth authorization

 note:
   the project must have view permissions for kube-system
"
exit 1
}

[[ -n ${datasource_name} ]] || usage

if [[ ${oauth} = true ]]; then
    yaml="grafana-ocp-oauth.yaml"; protocol="https://"; echo "deploying with oauth";
fi



oc new-project grafana
oc process -f "${yaml}" |oc create -f -
oc rollout status deployment/grafana-ocp
oc adm policy add-role-to-user view -z grafana-ocp -n kube-system

payload="$( mktemp )"
cat <<EOF >"${payload}"
{
"name": "${datasource_name}",
"type": "prometheus",
"typeLogoUrl": "",
"access": "proxy",
"url": "https://$( oc get route prometheus -n "${prometheus_namespace}" -o jsonpath='{.spec.host}' )",
"basicAuth": false,
"withCredentials": false,
"jsonData": {
    "tlsSkipVerify":true,
    "token":"$( oc sa get-token grafana-ocp )"
}
}
EOF

grafana_host="${protocol}$( oc get route grafana-ocp -o jsonpath='{.spec.host}' )"
curl -H "Content-Type: application/json" -u admin:admin "${grafana_host}/api/datasources" -X POST -d "@${payload}"

dashboard_file="./openshift-cluster-monitoring.json"
sed -i.bak "s/\${DS_PR}/${datasource_name}/" "${dashboard_file}"
curl -H "Content-Type: application/json" -u admin:admin "${grafana_host}/api/dashboards/db" -X POST -d "@${dashboard_file}"
mv "${dashboard_file}.bak" "${dashboard_file}"


exit 0
