# Usar una imagen base de Ubuntu
FROM ubuntu:latest

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Crear un archivo de script que imprima "Hola Mundo"
RUN echo 'echo "Hola Mundo desde Docker!"' > hola_mundo.sh

# Darle permisos de ejecución al script
RUN chmod +x hola_mundo.sh

# Ejecutar el script cuando el contenedor se inicie
CMD ["./hola_mundo.sh"]
