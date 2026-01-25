ARGO_TOKEN="Bearer $(kubectl get secret argouser.service-account-token -o=jsonpath='{.data.token}' | base64 --decode)"
echo $ARGO_TOKEN