# debian image with useful commands for code-server

    docker build --build-arg CSV=4.101.2 -t d-ctr.otvl.org/code-server-upstream:4.101.2 .
    docker login -u ctr d-ctr.otvl.org
    docker push d-ctr.otvl.org/code-server-upstream:4.101.2
    docker run -it --rm d-ctr.otvl.org/code-server-upstream:4.101.2 bash