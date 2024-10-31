# Usa la imagen de nginx estable
FROM nginx:stable

# Instala ModSecurity y sus dependencias
RUN apt-get update && \
    apt-get install -y libmodsecurity3 modsecurity-crs wget && \
    rm -rf /var/lib/apt/lists/*

# Descarga y descomprime OWASP ModSecurity CRS
RUN wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/refs/tags/v3.3.4.tar.gz -O /tmp/crs.tar.gz && \
    mkdir /usr/share/modsecurity-crs && \
    tar -xzf /tmp/crs.tar.gz -C /usr/share/modsecurity-crs --strip-components=1 && \
    rm /tmp/crs.tar.gz

# Copia la configuración de NGINX
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copia los archivos de configuración de ModSecurity
RUN cp /usr/share/modsecurity-crs/crs-setup.conf.example /etc/modsecurity.d/crs-setup.conf && \
    cp -r /usr/share/modsecurity-crs/rules /etc/modsecurity.d/

# Activa ModSecurity en la configuración de NGINX
RUN echo "Include /etc/modsecurity.d/crs-setup.conf" >> /etc/nginx/nginx.conf && \
    echo "Include /etc/modsecurity.d/rules/*.conf" >> /etc/nginx/nginx.conf

RUN echo "SecRuleEngine On" >> /etc/modsecurity.d/crs-setup.conf

# Exponer el puerto 80 y 443
EXPOSE 80 443

# Inicia NGINX
CMD ["nginx", "-g", "daemon off;"]
