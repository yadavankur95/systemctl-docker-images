ARG version=22.04

FROM ubuntu:${version}

RUN apt-get update && apt-get upgrade -y

RUN apt-get install curl vim gpg sudo less systemctl -y

RUN apt-get install init -y

COPY ../scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/init"]
