FROM alpine:3.7

RUN apk update && \
    apk add krb5-server krb5

COPY ./kerberos/env-config.sh /var/lib/krb5kdc/env-config.sh
COPY ./kerberos/configure.sh /var/lib/krb5kdc/

ENTRYPOINT [ "sh", "/var/lib/krb5kdc/configure.sh"]
