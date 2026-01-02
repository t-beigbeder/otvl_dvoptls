docker build -t t-ctr.otvl.org/dv-dev-tools:go .
docker push t-ctr.otvl.org/dv-dev-tools:go
kubectl run -it dvops --rm --image=t-ctr.otvl.org/dv-dev-tools:1.0.0 -- bash