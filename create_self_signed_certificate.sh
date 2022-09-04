#!/bin/bash

rm -rf certs
mkdir -p certs/instance
mkdir -p certs/load-balancer

echo 'Create keys to ssh bastion and webservers'
ssh-keygen -t rsa -b 2048 -f certs/instance/key.pem -P ""

echo 'Generate certs for load balancer'
cd certs/load-balancer
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj "/C=FR/ST=PACA/L=Aix/O=cpauliat/OU=home/CN=lb07c.cpauliat.eu"
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
openssl genrsa -out loadbalancer.key 2048
openssl req -new -key loadbalancer.key -out loadbalancer.csr -subj "/C=FR/ST=PACA/L=Aix/O=cpauliat/OU=home/CN=lb07c.cpauliat.eu"
openssl x509 -req -in loadbalancer.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out loadbalancer.crt -days 50000
openssl x509 -in loadbalancer.crt -text

cd ../..