# debian image with useful commands for code-server

    sudo docker build --build-arg CODE_RELEASE=4.101.2 -t code-server-debian:4.101.2 -t t-ctr.otvl.org/code-server-debian:4.101.2 .
    sudo docker login 
    sudo docker push t-ctr.otvl.org/code-server-debian:4.101.2
    sudo docker run -it --rm t-ctr.otvl.org/code-server-debian:4.101.2 bash