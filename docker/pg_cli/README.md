docker build -t t-ctr.otvl.org/otvl-pg-cli:0.1 .
docker push t-ctr.otvl.org/otvl-pg-cli:0.1
kubectl run -it dvops --rm --image=t-ctr.otvl.org/otvl-pg-cli:0.1 -- bash

    # time pg_dump -Fc test_load_wiki_fr > /tmp/test_load_wiki_fr.pgd
pg_restore -h t-db-pgs -C -d test_load_wiki_fr test_load_wiki_fr-20260101.pgd

pg_dumpall -h t-db-pgs > /tmp/all.pgd