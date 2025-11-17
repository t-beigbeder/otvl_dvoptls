# debian image with useful commands for theia-ide browser

    docker build --build-arg THV=1.66.2 -t t-ctr.otvl.org/theia:1.66.2 .
    docker login -u ctr t-ctr.otvl.org
    docker push t-ctr.otvl.org/theia:1.66.2
    docker run -it --rm t-ctr.otvl.org/theia:1.66.2 bash