FROM ubuntu:latest
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales python-configparser python3-wxgtk4.0 python3-ujson python3-pyudev whois vlc wget sudo avahi-daemon avahi-discover avahi-utils libnss-mdns mdns-scan libavahi-compat-libdnssd-dev gnupg gnupg1 gnupg2

RUN mkdir -p /home/root/
WORKDIR /home/root/

# Startup script
COPY startup.sh startup.sh
RUN chmod +x startup.sh
COPY avahi/avahi-dbus.conf /etc/dbus-1/system.d/avahi-dbus.conf

USER root
RUN mkdir -p /var/run/dbus/
RUN chmod -R 777 /var/run/dbus/
RUN mkdir -p /var/run/avahi-daemon/
RUN chmod -R 777 /var/run/avahi-daemon/
RUN chown -R avahi:avahi /var/run/avahi-daemon/

RUN \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

#RUN \
#    sed -i -e 's/# fi_FI.UTF-8 UTF-8/fi_FI.UTF-8 UTF-8/' /etc/locale.gen && \
#    dpkg-reconfigure --frontend=noninteractive locales && \
#    update-locale LC_NUMERIC=fi_FI.UTF-8 \
#    update-locale LC_TIME=fi_FI.UTF-8

ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN wget https://github.com/openplotter/openplotter-settings/releases/download/v2.5.0-stable/openplotter-settings_2.5.0-stable_all.deb
RUN dpkg -i openplotter-settings_2.5.0-stable_all.deb
CMD ["bash"]
