FROM nginx:1.21-alpine

MAINTAINER Levente Farkas (levente.farkas@egi.eu)

# Build-time variables specified by docker-compose.yml / .env
ARG DC_DTM_SERVICE_URL
ARG DC_DTM_SERVICE_DOMAIN
ARG WF_DTM_SERVICE_URL
ARG WF_DTM_SERVICE_DOMAIN
ARG SERVICE_EMAIL

# Define environment variables
ENV DC_DTM_SERVICE_URL ${DC_DTM_SERVICE_URL}
ENV DC_DTM_SERVICE_DOMAIN ${DC_DTM_SERVICE_DOMAIN}
ENV WF_DTM_SERVICE_URL ${WF_DTM_SERVICE_URL}
ENV WF_DTM_SERVICE_DOMAIN ${WF_DTM_SERVICE_DOMAIN}
ENV EMAIL ${SERVICE_EMAIL}

# Install certbot and openssl
# Using inotifywait to watch our certificates and trigger actions on change
RUN apk add inotify-tools openssl certbot

# Configure website
COPY ssl/ /etc/ssl-options
COPY nginx.conf /etc/nginx/nginx.conf
COPY cert-nginx.conf /etc/nginx/conf.d/default.conf.template
RUN envsubst '${DC_DTM_SERVICE_DOMAIN}${DC_DTM_SERVICE_URL}${WF_DTM_SERVICE_DOMAIN}${WF_DTM_SERVICE_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && \
    rm -f /etc/nginx/conf.d/default.conf.template && \
    rm -f /etc/nginx/sites-enabled/default && \
    mkdir -p /var/cache/nginx/proxycache && \
    mkdir -p /var/cache/nginx/proxytemp

WORKDIR /opt
COPY cert-entrypoint.sh entrypoint.sh
COPY cert-request.sh request.sh
COPY health-check.sh status.sh

RUN chmod a+x entrypoint.sh && \
    chmod a+x request.sh && \
    chmod a+x status.sh

EXPOSE 80 443

ENTRYPOINT ["./entrypoint.sh"]
