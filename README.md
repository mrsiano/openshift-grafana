# grafana-ocp

### How To:
1. docker pull docker.io/mrsiano/grafana-ocp
2. docker run -d -ti -p 3000:3000 mrsiano/grafana-ocp "./bin/grafana-server"
3. @openshift master node run and grab the token string:
```
oc sa get-token management-admin -n management-infra
```
4. add new prometheus DS to grafana.
5. paste the token string at the token field.
6. checkout the TLS checkbox.

### Build the docker image
1. docker build -t grafana-ocp .
2. docker run -d -ti -p 3000:3000 grafana-ocp "./bin/grafana-server"