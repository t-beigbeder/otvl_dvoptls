# debian image with useful commands for code-server

    sudo docker build -t code-server-upstream:4.101.2 -t t-ctr.otvl.org/code-server-debian:4.101.2 .
    sudo docker login 
    sudo docker push t-ctr.otvl.org/code-server-upstream:4.101.2
    sudo docker run -it --rm t-ctr.otvl.org/code-server-upstream:4.101.2 bash