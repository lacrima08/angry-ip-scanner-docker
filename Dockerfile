FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# 1. Création des dossiers man manquants pour OpenJDK
RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2 /usr/share/man/man3 /usr/share/man/man4 /usr/share/man/man5 /usr/share/man/man6 /usr/share/man/man7 /usr/share/man/man8

# 2. Installation des dépendances (ajout de curl et jq pour l'API GitHub)
RUN apt-get update && apt-get install -y \
    default-jre \
    gstreamer1.0-plugins-base \
    curl \
    jq \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 3. Récupération dynamique et installation de la DERNIÈRE version d'Angry IP Scanner
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/angryip/ipscan/releases/latest | jq -r '.tag_name') \
    && echo "Installation de la version : ${LATEST_VERSION}" \
    && curl -sL "https://github.com/angryip/ipscan/releases/download/${LATEST_VERSION}/ipscan_${LATEST_VERSION}_amd64.deb" -o /tmp/ipscan.deb \
    && dpkg -i /tmp/ipscan.deb || apt-get install -f -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 4. Configuration de l'autostart
RUN mkdir -p /defaults && echo "ipscan" > /defaults/autostart

