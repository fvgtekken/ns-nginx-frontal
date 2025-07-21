# Usa una imagen base específica de NGINX
FROM nginx:1.21.6-alpine

# Instala las dependencias necesarias para ModSecurity y compilación
RUN apk add --no-cache \
    build-base \
    curl \
    git \
    libtool \
    automake \
    autoconf \
    pcre-dev \
    pcre2-dev \  
    openssl-dev \
    linux-headers \
    zlib-dev \
    yajl-dev \
    libxml2-dev

# Clona el repositorio de ModSecurity en una versión estable 
# https://github.com/owasp-modsecurity/ModSecurity-nginx.git
# https://github.com/owasp-modsecurity/ModSecurity.git
# RUN git clone --depth 1 -b v3.0.4 https://github.com/SpiderLabs/ModSecurity.git /modsecurity

RUN git clone https://github.com/owasp-modsecurity/ModSecurity.git /modsecurity

# Inicializa y actualiza los submódulos de ModSecurity
RUN cd /modsecurity && \
    git submodule init && \
    git submodule update

# Compila e instala ModSecurity
RUN cd /modsecurity && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

# Clona el repositorio de ModSecurity-nginx
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /modsecurity-nginx

# Descarga y descomprime el código fuente de la versión de NGINX compatible
RUN curl -L https://nginx.org/download/nginx-1.21.6.tar.gz | tar zx -C / && \
    mv /nginx-1.21.6 /nginx

# Compila e instala el módulo ModSecurity para NGINX
RUN cd /nginx && \
    ./configure --with-compat --add-dynamic-module=../modsecurity-nginx && \
    make modules && \
    cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules/

# Copia el archivo de configuración de NGINX y ModSecurity
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/modsec.conf /etc/nginx/modsec.conf
COPY nginx/rules /etc/nginx/rules

# Expone el puerto 80
EXPOSE 80

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]
