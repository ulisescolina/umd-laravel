FROM bitnami/oraclelinux-extras:7-r431
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack php-7.1.31-0 --checksum 80cd0ea77424f62c759fd73d87fe3d00bd34885750715c8e3b71f34b6834df63
RUN bitnami-pkg install node-8.16.1-0 --checksum 88ef5ed4cdd0be0be0d3ac7296749e53e9adbfe0d7b0cde6da8be44dad5eba01
RUN bitnami-pkg install laravel-5.8.17-1 --checksum 2482006dd94e5922eec67686b4831719be012a250d6c3d14cd05862ff52efd59
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="5.8.17-ol-7-r95" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
