FROM debian:buster-slim

ARG hlds_build=7882
ARG metamod_version=1.21p38
ARG amxmod_version=1.8.2
ARG steamcmd_url=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
ARG hlds_url="https://github.com/DevilBoy-eXe/hlds/releases/download/$hlds_build/hlds_build_$hlds_build.zip"
ARG metamod_url="https://github.com/Bots-United/metamod-p/releases/download/v$metamod_version/metamod_i686_linux_win32-$metamod_version.tar.xz"
ARG amxmod_url="http://www.amxmodx.org/release/amxmodx-$amxmod_version-base-linux.tar.gz"

# Configuración base (sin versiones específicas)
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    ca-certificates \
    curl \
    lib32gcc1 \
    unzip \
    xz-utils \
    zip \
 && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8 LC_ALL=en_US.UTF-8 CPU_MHZ=2300

RUN groupadd -r steam && useradd -r -g steam -m -d /opt/steam steam

USER steam
WORKDIR /opt/steam
COPY ./lib/hlds.install .

# Instalación HLDS (original)
RUN curl -sL "$steamcmd_url" | tar xzvf - \
    && ./steamcmd.sh +runscript hlds.install

# Descargar HLDS build pero eliminar otros mapas después
RUN curl -sLJO "$hlds_url" \
    && unzip "hlds_build_$hlds_build.zip" -d "/opt/steam" \
    && cp -R "hlds_build_$hlds_build"/* hlds/ \
    && rm -rf "hlds_build_$hlds_build" "hlds_build_$hlds_build.zip" \
    && find /opt/steam/hlds/valve/maps/ -type f ! -name 'crossfire.bsp' -delete

# Configuración steamclient (original)
RUN mkdir -p "$HOME/.steam" \
    && ln -s /opt/steam/linux32 "$HOME/.steam/sdk32"

# Archivos base (original)
RUN touch /opt/steam/hlds/valve/listip.cfg \
    && touch /opt/steam/hlds/valve/banned.cfg

# Metamod (original)
RUN mkdir -p /opt/steam/hlds/valve/addons/metamod/dlls \
    && touch /opt/steam/hlds/valve/addons/metamod/plugins.ini \
    && curl -sqL "$metamod_url" | tar -C /opt/steam/hlds/valve/addons/metamod/dlls -xJ \
    && sed -i 's/dlls\/hl\.so/addons\/metamod\/dlls\/metamod.so/g' /opt/steam/hlds/valve/liblist.gam

# AMX Mod X (original PERO sin mapcycle.txt automático)
RUN curl -sqL "$amxmod_url" | tar -C /opt/steam/hlds/valve/ -zxvf - \
    && echo 'linux addons/amxmodx/dlls/amxmodx_mm_i386.so' >> /opt/steam/hlds/valve/addons/metamod/plugins.ini \
    && echo "crossfire" > /opt/steam/hlds/valve/mapcycle.txt

# dproto (original)
RUN mkdir -p /opt/steam/hlds/valve/addons/dproto
COPY lib/dproto/bin/Linux/dproto_i386.so /opt/steam/hlds/valve/addons/dproto/dproto_i386.so
COPY lib/dproto/dproto.cfg /opt/steam/hlds/valve/dproto.cfg
RUN echo 'linux addons/dproto/dproto_i386.so' >> /opt/steam/hlds/valve/addons/metamod/plugins.ini
COPY lib/dproto/amxx/* /opt/steam/hlds/valve/addons/amxmodx/scripting/

# bind_key (original)
COPY lib/bind_key/amxx/bind_key.amxx /opt/steam/hlds/valve/addons/amxmodx/plugins/bind_key.amxx
RUN echo 'bind_key.amxx            ; binds keys for voting' >> /opt/steam/hlds/valve/addons/amxmodx/configs/plugins.ini

# Configuración final (original)
WORKDIR /opt/steam/hlds
COPY valve valve
RUN chmod +x hlds_run hlds_linux \
    && echo 70 > steam_appid.txt

EXPOSE 27015/udp
ENTRYPOINT ["./hlds_run", "-timeout", "3", "-pingboost", "1"]
CMD ["+map", "crossfire", "+maxplayers", "12", "-nomaster", "+sv_visible", "0"]