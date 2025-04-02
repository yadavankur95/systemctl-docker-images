FROM yadavankur95/almalinux:9

RUN yum install httpd -y && systemctl enable httpd

COPY ./custom-entrypoint.sh /custom-entrypoint.sh

EXPOSE 80