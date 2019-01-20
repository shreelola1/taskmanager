#!/bin/bash

sudo mkdir -p /private/registry/data
sudo mkdir -p /private/registry/auth
sudo mkdir -p /private/registry/cert
sudo chown -R $(whoami) /private/registry/

sudo docker run --entrypoint htpasswd registry:2 -Bbn admin admin > /private/registry/auth/htpasswd

sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout /private/registry/cert/domain.key -x509 -days 365 -subj '/emailAddress=devops@internal-registry.com/C=IN/ST=IN/L=Bangalore/O=Shree/OU=IT/CN=internal-registry.com' -out /private/registry/cert/domain.crt

sudo docker run -p 5000:5000 --restart=always  -v /private/registry/data:/var/lib/registry -v /private/registry/auth:/auth -v /private/registry/cert:/cert -e REGISTRY_AUTH=htpasswd -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" -e REGISTRY_HTTP_TLS_CERTIFICATE=/cert/domain.crt -e  REGISTRY_HTTP_TLS_KEY=/cert/domain.key registry:2
