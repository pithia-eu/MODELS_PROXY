#!/bin/sh

if [ ! -f /var/www/html ]; then
    mkdir -p /var/www/html
fi
 
if [ -n "$DC_DTM_SERVICE_DOMAIN" ] && [ "$DC_DTM_SERVICE_DOMAIN" != "localhost" ]; then
	certbot certonly \
			--config-dir ${LETSENCRYPT_DIR:-/etc/letsencrypt} \
			--dry-run \
			--agree-tos \
			--DC_DTM_SERVICE_DOMAINs "$DC_DTM_SERVICE_DOMAIN" \
			--email $EMAIL \
			--expand \
			--noninteractive \
			--webroot \
			--webroot-path /var/www/html \
			$OPTIONS || true

	if [ -f ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$DC_DTM_SERVICE_DOMAIN/privkey.pem ]; then
		chmod +rx ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live
		chmod +rx ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive
		chmod +r  ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive/${DC_DTM_SERVICE_DOMAIN}/fullchain*.pem
		chmod +r  ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive/${DC_DTM_SERVICE_DOMAIN}/privkey*.pem
		cp ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$DC_DTM_SERVICE_DOMAIN/privkey.pem /usr/share/nginx/certificates/$DC_DTM_SERVICE_DOMAIN/privkey.pem
		cp ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$DC_DTM_SERVICE_DOMAIN/fullchain.pem /usr/share/nginx/certificates/$DC_DTM_SERVICE_DOMAIN/fullchain.pem
		echo "Copied new certificate to /usr/share/nginx/certificates"
	fi
fi

if [ -n "$WF_DTM_SERVICE_DOMAIN" ] && [ "$WF_DTM_SERVICE_DOMAIN" != "localhost" ]; then
	certbot certonly \
			--config-dir ${LETSENCRYPT_DIR:-/etc/letsencrypt} \
			--dry-run \
			--agree-tos \
			--WF_DTM_SERVICE_DOMAINs "$WF_DTM_SERVICE_DOMAIN" \
			--email $EMAIL \
			--expand \
			--noninteractive \
			--webroot \
			--webroot-path /var/www/html \
			$OPTIONS || true

	if [ -f ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$WF_DTM_SERVICE_DOMAIN/privkey.pem ]; then
		chmod +rx ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live
		chmod +rx ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive
		chmod +r  ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive/${WF_DTM_SERVICE_DOMAIN}/fullchain*.pem
		chmod +r  ${LETSENCRYPT_DIR:-/etc/letsencrypt}/archive/${WF_DTM_SERVICE_DOMAIN}/privkey*.pem
		cp ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$WF_DTM_SERVICE_DOMAIN/privkey.pem /usr/share/nginx/certificates/$WF_DTM_SERVICE_DOMAIN/privkey.pem
		cp ${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$WF_DTM_SERVICE_DOMAIN/fullchain.pem /usr/share/nginx/certificates/$WF_DTM_SERVICE_DOMAIN/fullchain.pem
		echo "Copied new certificate to /usr/share/nginx/certificates"
	fi
fi