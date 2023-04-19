FROM coturn/coturn:alpine AS dev
USER root:root
RUN apk add curl netcat-openbsd
COPY files/coturn/certs/key.pem /certs/key.pem
COPY files/coturn/certs/cert.pem /certs/cert.pem
COPY files/coturn/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
