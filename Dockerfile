# Usar una imagen base de NGINX
FROM nginx:latest

# Instalar las dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    libxml2-dev \
    libcurl4-openssl-dev \
    libjansson-dev \
    libpcre3-dev \
    libssl-dev \
    wget

# Clonar el repositorio de ModSecurity
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity.git /modsecurity && \
    cd /modsecurity && \
    git checkout v3.0.4 && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

# Clonar el conector de ModSecurity para NGINX
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /modsecurity-nginx

# Configurar el módulo de ModSecurity en NGINX
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -xzvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6 && \
    ./configure --with-compat --add-module=/modsecurity-nginx && \
    make && \
    make install

# Copiar el archivo de configuración de NGINX
COPY nginx/nginx.conf /etc/nginx/nginx.conf
# Crear un archivo de configuración de ModSecurity
RUN echo "SecRuleEngine On\nSecRequestBodyAccess On\nInclude /etc/nginx/owasp-modsecurity-crs/base_rules/*.conf" > /etc/nginx/modsec.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]
