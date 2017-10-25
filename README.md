# grafana-ocp

Note: make sure to have openshift prometheus deployed.


## Deploy on openshift cluster
```
./redeploy-prometheus.sh deploy
./setup-grafana.sh prometheus-ocp
```

## Deploy on openshift cluster with grafana manually

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
