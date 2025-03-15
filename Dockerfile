FROM kalilinux/kali-rolling

# Configurar el entorno para instalaciones no interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y xfce4 xfce4-goodies xrdp dbus-x11 sudo kali-desktop-xfce && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear el usuario "kali" y darle privilegios de sudo
RUN adduser --disabled-password --gecos "" kali && \
    echo 'kali:kali' | chpasswd && \
    usermod -aG sudo kali

# Herramientas generales de kali
RUN apt-get update && apt-get upgrade -y && \
    apt-get install kali-tools-top10 -y

# Asegurar que XRDP pueda acceder a los certificados SSL
RUN adduser xrdp ssl-cert

# Configurar XFCE como entorno de escritorio por defecto para XRDP
RUN echo "startxfce4" > /etc/skel/.xsession && \
    mkdir -p /var/run/dbus && \
    ln -sf /etc/skel/.xsession /home/kali/.xsession && \
    chown kali:kali /home/kali/.xsession

# Exponer el puerto para RDP
EXPOSE 3389

# Eliminar archivos de PID de servicios antiguos y luego iniciar XRDP
CMD rm -f /var/run/dbus/pid /var/run/xrdp/xrdp-sesman.pid && \
    service dbus start && \
    service xrdp start && \
    exec /usr/sbin/xrdp -nodaemon
