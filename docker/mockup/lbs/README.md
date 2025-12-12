docker build -t t-ctr.otvl.org/label-studio:1.21 .
kubectl run lbs --rm --image=t-ctr.otvl.org/label-studio:1.21 -- /venv/bin/label-studio