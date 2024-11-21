Explicación de cada regla:
REQUEST-913-SCANNER-DETECTION.conf

Propósito: Detecta herramientas de escaneo y automatización que buscan vulnerabilidades en tu sitio (por ejemplo, nmap, SQLMap).
Ejemplo: Si un atacante usa una herramienta para escanear tu aplicación en busca de debilidades, esta regla intenta bloquear esas solicitudes.
Prueba: Usa una herramienta como nmap o Nikto para escanear tu sitio y verifica si el WAF bloquea la actividad.
REQUEST-941-APPLICATION-ATTACK-XSS.conf

Propósito: Previene ataques de Cross-Site Scripting (XSS), donde se inyecta código malicioso en una página web.
Ejemplo: Si un atacante intenta enviar <script>alert("XSS")</script> en un formulario o URL.
Prueba: Inserta un script sencillo (<script>alert('test')</script>) en un campo de entrada o URL y verifica si el WAF lo bloquea.
REQUEST-930-APPLICATION-ATTACK-LFI.conf

Propósito: Bloquea ataques de Local File Inclusion (LFI), que permiten al atacante acceder a archivos internos del servidor.
Ejemplo: Un atacante intenta acceder a /etc/passwd mediante la URL de tu aplicación.
Prueba: Intenta agregar ../../etc/passwd en la URL o parámetros de la aplicación y verifica si se bloquea.
REQUEST-931-APPLICATION-ATTACK-RFI.conf

Propósito: Previene ataques de Remote File Inclusion (RFI), donde se intenta incluir archivos remotos en la aplicación.
Ejemplo: Un atacante intenta cargar un archivo malicioso desde un servidor externo (ej., http://malicious.com/shell.php).
Prueba: Prueba incluir un enlace como http://example.com/evil.php en un parámetro de URL y verifica si el WAF lo bloquea.
REQUEST-932-APPLICATION-ATTACK-RCE.conf

Propósito: Protege contra ataques de ejecución remota de comandos (RCE), en los cuales un atacante ejecuta comandos en el servidor.
Ejemplo: Si un atacante intenta pasar comandos como ; ls en un campo de texto para listar archivos en el servidor.
Prueba: Inserta una cadena de comandos maliciosos, como ; ls o && cat /etc/passwd, en un campo de texto y verifica el bloqueo.
REQUEST-949-BLOCKING-EVALUATION.conf

Propósito: Aplica la evaluación final para bloquear o permitir la solicitud según las reglas anteriores.
Ejemplo: Esta regla se asegura de que cualquier solicitud que haya violado una regla se bloquee.
Prueba: No tiene una prueba específica, ya que actúa en conjunto con las demás.
REQUEST-921-PROTOCOL-ATTACK.conf

Propósito: Detecta ataques basados en el protocolo HTTP (por ejemplo, requests malformados o caracteres prohibidos).
Ejemplo: Si un atacante intenta usar caracteres no válidos en los encabezados HTTP para explotar debilidades en el servidor.
Prueba: Intenta enviar una solicitud con un encabezado extraño o valores no estándar y verifica si se bloquea.
REQUEST-920-PROTOCOL-ENFORCEMENT.conf

Propósito: Enfoca en la validez de los requests HTTP, aplicando controles estrictos en los encabezados y la estructura.
Ejemplo: Solicitudes con verbos HTTP no permitidos o métodos extraños.
Prueba: Envía un request con un método HTTP no estándar (como TRACK) y verifica si se bloquea.
REQUEST-942-APPLICATION-ATTACK-SQLI.conf

Propósito: Protege contra ataques de inyección SQL (SQLi), donde un atacante intenta ejecutar comandos SQL en la base de datos.
Ejemplo: Un atacante envía un parámetro como ' OR '1'='1 en un campo de entrada de usuario.
Prueba: Envía un input con una inyección SQL básica, como ' OR '1'='1, en un campo de búsqueda o formulario.

https://nextjs.org/docs/pages/building-your-application/configuring/content-security-policy#adding-a-nonce-with-middleware

start nginx s
