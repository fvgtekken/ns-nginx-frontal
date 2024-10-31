# Usar una imagen base de NGINX
FROM nginx:1.21.6

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
RUN git clone https://github.com/SpiderLabs/ModSecurity.git /modsecurity && \
    cd /modsecurity && \
    git checkout v3.0.5 && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure && \
    make && \
    make install


# Clonar el conector de ModSecurity para NGINX
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /modsecurity-nginx

# Clonar el repositorio de ModSecurity
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity.git /modsecurity && \
    cd /modsecurity && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure && \
    make && \
    make install


# Copiar el archivo de configuración de NGINX
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Descargar y configurar OWASP ModSecurity CRS
RUN git clone https://github.com/coreruleset/coreruleset.git /etc/nginx/owasp-modsecurity-crs && \
    mv /etc/nginx/owasp-modsecurity-crs/crs-3.3.0/* /etc/nginx/owasp-modsecurity-crs/ && \
    rm -rf /etc/nginx/owasp-modsecurity-crs/crs-3.3.0

# Crear un archivo de configuración de ModSecurity
RUN echo "SecRuleEngine On\nSecRequestBodyAccess On\nInclude /etc/nginx/owasp-modsecurity-crs/*.conf" > /etc/nginx/modsec.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar NGINX
CMD ["nginx", "-g", "daemon off;"]
