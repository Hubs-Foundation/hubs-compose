#!/bin/bash

echo "realm=${REALM}" > /etc/turnserver.conf
echo "min-port=${MIN_PORT}" >> /etc/turnserver.conf
echo "max-port=${MAX_PORT}" >> /etc/turnserver.conf 
echo "tls-listening-port=${TLS_PORT}" >> /etc/turnserver.conf 
echo "psql-userdb=${PSQL}" >> /etc/turnserver.conf 
echo "lt-cred-mech=true" >> /etc/turnserver.conf
echo "use-auth-secret=true" >> /etc/turnserver.conf
echo "cert=/certs/cert.pem" >> /etc/turnserver.conf 
echo "pkey=/certs/key.pem" >> /etc/turnserver.conf
echo "verbose" >> /etc/turnserver.conf 

echo "####################################################" 
cat /etc/turnserver.conf
echo "####################################################" 

turnserver --log-file=stdout
