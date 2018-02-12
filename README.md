# Openshift Grafana Dashboards

Research repository, see the origin page for official example
https://github.com/openshift/origin/tree/master/examples/grafana

## Available Dashboards
- openshift cluster metrics
- node exporter metrics

## To deploy grafana
Note: make sure to have openshift prometheus deployed.
(https://github.com/openshift/origin/tree/master/examples/prometheus)

``` ./setup-grafana.sh prometheus-ocp prometheus false ``` - for byo cluster (prometheus selfdeployment).

``` ./setup-grafana.sh prometheus-ocp openshift-metrics true ``` - for byo cluster that uses openshift_metrics plus oauth.

## How to use oauth proxy:
Note: when using oauth make sure your user has permission to browse grafana.
- add a openshift user htpasswd ```htpasswd -c /etc/origin/master/htpasswd gfadmin```
- use the HTPasswdPasswordIdentityProvider as described here - https://docs.openshift.com/enterprise/3.0/admin_guide/configuring_authentication.html 
- make sure point the provider file to /etc/origin/master/htpasswd.
  or using this example cmd:
  ```
  sed -ie 's|AllowAllPasswordIdentityProvider|HTPasswdPasswordIdentityProvider\n      file: /etc/origin/master/htpasswd|' /etc/origin/master/master-config.yaml
  ```
- add view role to user ```oc adm policy add-cluster-role-to-user cluster-reader gfadmin```
- restart master api ```systemctl restart atomic-openshift-master-api.service```
- get the grafana url by ```oc get route```
- discover your openshift dashboard.

## Deploy grafana manually

(https://github.com/openshift/origin/tree/master/examples/prometheus)

1. ```oc create project grafana```
2. ```oc new-app -f grafana-ocp.yaml```
3. ```oc expose svc grafana-ocp```
4. grab the grafana url ``` oc get route |awk 'NR==2 {print $2}' ```
5. grab the ocp token, from openshift master run: ```oc sa get-token management-admin -n management-infra```
6. browse to grafana via browser and add new prometheus DS to grafana.
7. paste the token string at the token field.
8. checkout the TLS checkbox.
9. save & test and make sure all green.

### Pull standalone docker grafana instance
1. ```docker pull docker.io/mrsiano/grafana-ocp```
2. ```docker run -d -ti -p 3000:3000 mrsiano/grafana-ocp "./bin/grafana-server"```

### Build and run the docker image
1. ```docker build -t grafana-ocp .```
2. ```docker run -d -ti -p 3000:3000 grafana-ocp "./bin/grafana-server"```

#### Resources 
- example video https://youtu.be/srCApR_J3Os
- deploy openshift prometheus https://github.com/openshift/origin/tree/master/examples/prometheus 
