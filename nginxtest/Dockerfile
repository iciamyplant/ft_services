FROM alpine:latest

EXPOSE 80
RUN apk update ; apk add nginx ; apk add openrc


RUN openrc ; touch run/openrc/softlevel
CMD service nginx start ; sleep infinity


