docker build -t t-ctr.otvl.org/otvl-pg-cli:0.1 .
docker push t-ctr.otvl.org/otvl-pg-cli:0.1
kubectl run -it dvops --rm --image=t-ctr.otvl.org/otvl-pg-cli:0.1 -- bash
helm install t-db-2 ./ds_pg --set images.pg=postgres:18 --set images.pg_cli=t-ctr.otvl.org/otvl-pg-cli:0.7 --set s3.url_prefix=s3://otvl-backups/ds-pg-backups

    # time pg_dump -Fc test_load_wiki_fr > /tmp/test_load_wiki_fr.pgd
pg_restore -h t-db-pgs -c -C -d postgres test_load_wiki_fr-20260101.pgd

pg_dumpall -h t-db-pgs -c > /tmp/all.pgd
psql -h t-db-pgs -d postgres < /tmp/all.pgd

https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination-flow
