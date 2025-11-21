    docker build --build-arg CSV=4.101.2 -t t-ctr.otvl.org/code-server-upstream:4.101.2 .
    docker login -u ctr t-ctr.otvl.org
    docker push t-ctr.otvl.org/code-server-upstream:4.101.2
    docker run -it --rm t-ctr.otvl.org/code-server-upstream:4.101.2 bash