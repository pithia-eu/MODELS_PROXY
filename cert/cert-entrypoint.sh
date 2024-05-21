#!/bin/sh

export EMAIL=${EMAIL}

export DC_DTM_SERVICE_DOMAIN=${DC_DTM_SERVICE_DOMAIN}

# Ensure we have a folder for the certificates
if [ ! -d /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN ]; then
    echo "Creating DC_DTM_SERVICE_DOMAIN certificate folder"
    mkdir -p /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN
fi

### If certificates do not exist yet, create self-signed ones before we start nginx
if [ ! -f /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/fullchain.pem ]; then
    echo "Generating DC_DTM_SERVICE_DOMAIN self-signed certificate"
    openssl genrsa -out /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/privkey.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/privkey.pem -out /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/cert.csr -nodes -subj \
    "/C=PT/ST=World/L=World/O=$DC_DTM_SERVICE_DOMAIN/OU=egi lda/CN=$DC_DTM_SERVICE_DOMAIN"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/cert.csr -signkey /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/privkey.pem -out /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN/fullchain.pem
fi

if [ -n "$DC_DTM_SERVICE_DOMAIN" ] && [ "$DC_DTM_SERVICE_DOMAIN" != "localhost" ]; then
    ### Send certbot emission/renewal to background
    $(while :; do /opt/request.sh; sleep "${RENEW_INTERVAL:-12h}"; done;) &

    ### Check for changes in the certificate (i.e renewals or first start) in the background
    $(while inotifywait -e close_write /usr/share/nginx/certificates/DC_DTM_SERVICE_DOMAIN; do echo "Reloading nginx with DC_DTM_SERVICE_DOMAIN new certificate"; nginx -s reload; done) &
fi

export WF_DTM_SERVICE_DOMAIN=${WF_DTM_SERVICE_DOMAIN}

# Ensure we have a folder for the certificates
if [ ! -d /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN ]; then
    echo "Creating WF_DTM_SERVICE_DOMAIN certificate folder"
    mkdir -p /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN
fi

### If certificates do not exist yet, create self-signed ones before we start nginx
if [ ! -f /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/fullchain.pem ]; then
    echo "Generating WF_DTM_SERVICE_DOMAIN self-signed certificate"
    openssl genrsa -out /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/privkey.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/privkey.pem -out /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/cert.csr -nodes -subj \
    "/C=PT/ST=World/L=World/O=$WF_DTM_SERVICE_DOMAIN/OU=egi lda/CN=$WF_DTM_SERVICE_DOMAIN"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/cert.csr -signkey /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/privkey.pem -out /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN/fullchain.pem
fi

if [ -n "$WF_DTM_SERVICE_DOMAIN" ] && [ "$WF_DTM_SERVICE_DOMAIN" != "localhost" ]; then
    ### Send certbot emission/renewal to background
    $(while :; do /opt/request.sh; sleep "${RENEW_INTERVAL:-12h}"; done;) &

    ### Check for changes in the certificate (i.e renewals or first start) in the background
    $(while inotifywait -e close_write /usr/share/nginx/certificates/WF_DTM_SERVICE_DOMAIN; do echo "Reloading nginx with WF_DTM_SERVICE_DOMAIN new certificate"; nginx -s reload; done) &
fi


### Start nginx with daemon off as our main pid
echo "Starting nginx"
nginx
