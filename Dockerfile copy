# Stage de compilación
FROM alpine:latest as build-stage

# Instalar dependencias necesarias
RUN apk add --no-cache \
    git \
    build-base \
    automake \
    autoconf \
    libtool \
    pcre-dev \
    libxml2-dev \
    yajl-dev \
    curl-dev \
    openssl-dev \
    pkgconfig \
    flex \
    bison

# Clonar el repositorio de libmodsecurity
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity

# Compilar e instalar libmodsecurity
RUN cd ModSecurity && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

# Clonar el repositorio de ModSecurity-nginx
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

# Descargar y descomprimir NGINX
RUN curl -O http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -xzvf nginx-1.21.6.tar.gz

# Compilar e instalar NGINX con el módulo ModSecurity
RUN cd nginx-1.21.6 && \
    ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx && \
    make modules

# Descargar las reglas del OWASP CRS v4.3.0
RUN mkdir -p /usr/local/modsecurity/include && \
    curl -o /usr/local/modsecurity/include/owasp-crs.tar.gz -L https://github.com/coreruleset/coreruleset/archive/v4.3.0.tar.gz && \
    tar -xzvf /usr/local/modsecurity/include/owasp-crs.tar.gz -C /usr/local/modsecurity/include/ && \
    mv /usr/local/modsecurity/include/coreruleset-4.3.0 /usr/local/modsecurity/include/owasp-crs

# Stage de producción
FROM nginx:stable-alpine as production

# Copiar la biblioteca libmodsecurity de la etapa de compilación a la imagen final
COPY --from=build-stage /usr/local/lib/libmodsecurity.so* /usr/local/lib/
COPY --from=build-stage /usr/local/modsecurity/include/ /usr/local/modsecurity/include/

# Copiar el módulo ModSecurity compilado
COPY --from=build-stage /nginx-1.21.6/objs/ngx_http_modsecurity_module.so /etc/nginx/modules/

# Copiar las reglas del OWASP CRS v4.3.0 a la imagen final
COPY --from=build-stage /usr/local/modsecurity/include/owasp-crs /etc/modsecurity.d/owasp-crs

# Copiar el archivo de configuración de nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Exponer el puerto
EXPOSE 80

# Iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
