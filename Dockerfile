# Etapa 1: Construcción de ModSecurity y NGINX con su módulo
FROM nginx:1.21.6-alpine AS builder

# Instala las dependencias necesarias para ModSecurity y su compilación
RUN apk add --no-cache \
    build-base \
    curl \
    git \
    libtool \
    automake \
    autoconf \
    pcre-dev \
    openssl-dev \
    linux-headers \
    zlib-dev

# Clona el repositorio de ModSecurity en una versión estable
RUN git clone --depth 1 -b v3.0.4 https://github.com/SpiderLabs/ModSecurity.git /modsecurity

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

# Etapa 2: Imagen final de NGINX con ModSecurity
FROM nginx:1.21.6-alpine

# Copia el módulo de ModSecurity desde la imagen de construcción
COPY --from=builder /etc/nginx/modules/ngx_http_modsecurity_module.so /etc/nginx/modules/

# Copia los archivos de configuración
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/modsec.conf /etc/nginx/modsec.conf

# Copia las reglas iniciales (opcional, para que la imagen venga con algunas reglas)
COPY nginx/rules /etc/nginx/rules

# Expone el puerto 80
EXPOSE 80

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]
