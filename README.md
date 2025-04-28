# HLDS Docker - Minimalist Version (Crossfire Only) / Versión Minimalista (Solo Crossfire)

![Docker Icon](https://img.icons8.com/color/48/000000/docker.png)

## English Version

### Optimized Half-Life Dedicated Server for Docker

Modified version of the original HLDS server focused on:
- **Crossfire map only** (no map rotation)
- **No bots** (jk_botti removed)
- **Minimal configuration** for private servers

### 🚀 Quick Start

1. Clone the repository:
```bash
git clone https://github.com/tomasmetal23/hlds-docker-dproto.git
cd hlds-docker-dproto
```

2. Start the server:
```bash
docker-compose up -d
```

### 🔧 Modifications Made

#### ❌ Removed:
- All maps except `crossfire.bsp`
- Bot system (jk_botti)
- Automatic mapcycle
- Unofficial master servers

#### ✅ Maintained:
- Steam and non-Steam client compatibility (dproto)
- AMX Mod X 1.8.2 (essential functions only)
- Metamod-p 1.21p38
- Basic admin system

### ⚙️ Basic Configuration

#### Environment Variables (.env):
```ini
RCON_PASSWORD=your_secret_password
```

#### Ports:
- **27015/udp** - Main server port

### 🎮 Connect to Server
From the game console:
```bash
connect SERVER_IP:27015
```

---

## Versión en Español

### Servidor Half-Life Dedicated Server optimizado para Docker

Versión modificada del servidor HLDS original enfocada en:
- **Solo mapa Crossfire** (sin rotación automática)
- **Sin bots** (jk_botti eliminado)
- **Configuración mínima** para servidores privados

### 🚀 Inicio Rápido

1. Clona el repositorio:
```bash
git clone https://github.com/tomasmetal23/hlds-docker-dproto.git
cd hlds-docker-dproto
```

2. Inicia el servidor:
```bash
docker-compose up -d
```

### ⚙️ Configuración Básica

#### Variables de Entorno (.env):
```ini
RCON_PASSWORD=tu_password_secreto
```

#### Puertos:
- **27015/udp** - Puerto principal del servidor

### 🎮 Conectarse al Servidor
Desde la consola del juego:
```bash
connect IP_DEL_SERVIDOR:27015
```

---

### 📂 File Structure / Estructura de Archivos
```
/hlds-docker-minimal
├── docker-compose.yml
├── Dockerfile
├── .env
├── valve/
│   ├── maps/
│   │   └── crossfire.bsp  # Only included map / Único mapa incluido
│   └── config/            # (Optional) For custom configs / (Opcional) Para configs personalizadas
```

### 🛠 Advanced Customization / Personalización Avanzada

To add custom configurations:
1. Create a `server.cfg` file in `valve/config/`
2. Rebuild the container:
```bash
docker-compose down && docker-compose up -d --build
```

Para añadir configuraciones personalizadas:
1. Crea un archivo `server.cfg` en `valve/config/`
2. Reconstruye el contenedor:
```bash
docker-compose down && docker-compose up -d --build
```

### ℹ️ Technical Notes / Notas Técnicas
- HLDS Version: 7882 (Protocol 47/48)
- **dproto** 0.9.582 for mixed compatibility
- **-nomaster** mode enabled (server invisible in public lists)

- Versión HLDS: 7882 (Protocolo 47/48)
- **dproto** 0.9.582 para compatibilidad mixta
- Modo **-nomaster** activado (servidor invisible en listados públicos)

> ⚠️ This server is configured as private by default. To make it public, remove `-nomaster` and `+sv_visible 0` from docker-compose.yml
> ⚠️ Este servidor está configurado como privado por defecto. Para hacerlo público, elimina `-nomaster` y `+sv_visible 0` del docker-compose.yml
