# Entorno Hadoop Local - Laboratorio Educativo

Entorno completo de Hadoop con HDFS y Hive utilizando Docker, diseñado para fines educativos y prácticos.

## 📋 Contenido

- [Descripción](#descripción)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Ejemplos y Ejercicios](#ejemplos-y-ejercicios)
- [Arquitectura](#arquitectura)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Interfaces Web](#interfaces-web)
- [Solución de Problemas](#solución-de-problemas)
- [Recursos Adicionales](#recursos-adicionales)

## 📝 Descripción

Este proyecto proporciona un entorno Hadoop completo y funcional que incluye:

- **HDFS**: Sistema de archivos distribuido
- **Hive**: Data warehouse y motor de consultas SQL
- **YARN**: Gestor de recursos y scheduler
- **Base de datos de ejemplo**: Datos sintéticos de un sistema de ventas (Clientes, Productos, Ventas, Empleados, etc.)

Perfecto para:
- Aprender conceptos de Big Data
- Practicar HiveQL
- Entender arquitecturas distribuidas
- Preparar clases y talleres

## 🔧 Requisitos Previos

### Software Necesario

1. **Docker Desktop**
   - Windows: [Descargar](https://www.docker.com/products/docker-desktop)
   - Versión mínima: 20.10+
   
2. **Docker Compose**
   - Incluido en Docker Desktop
   - Versión mínima: 1.29+

3. **Git** (opcional, para clonar el repositorio)

### Requisitos del Sistema

- **RAM**: Mínimo 8 GB (recomendado 16 GB)
- **Espacio en disco**: ~5 GB libres
- **CPU**: 4 cores (recomendado)
- **Sistema Operativo**: Windows 10/11, macOS, o Linux

### Puertos Requeridos

Los siguientes puertos deben estar disponibles:
- `9870` - HDFS NameNode UI
- `8088` - YARN ResourceManager UI  
- `9000` - HDFS NameNode IPC
- `10000` - HiveServer2
- `9083` - Hive Metastore

## 🚀 Instalación

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/hadoop-example.git
cd hadoop-example
```

### Paso 2: Iniciar los Contenedores

```bash
docker-compose up -d
```

Este comando descargará las imágenes necesarias (primera vez ~3-4 GB) y iniciará todos los servicios.

### Paso 3: Verificar que los Servicios Están Activos

```bash
docker-compose ps
```

Deberías ver todos los servicios en estado `Up`.

### Paso 4: Inicializar HDFS y Cargar Datos

```bash
# Conectarse al contenedor namenode
docker exec -it namenode bash

# Ejecutar script de inicialización de HDFS
bash /scripts/init-hdfs.sh

# Cargar los datos CSV a HDFS
bash /scripts/load-data.sh

# Salir del contenedor
exit
```

### Paso 5: Crear las Tablas Hive

```bash
# Conectarse a Hive
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000

# Ejecutar el script de creación de tablas
!run /scripts/create-hive-tables.sql

# Verificar que las tablas se crearon
SHOW TABLES;

# Salir de beeline
!quit
```

¡Listo! Tu entorno Hadoop está funcionando.

## 💻 Uso

### Acceder a HDFS

```bash
# Conectarse al NameNode
docker exec -it namenode bash

# Listar archivos en HDFS
hdfs dfs -ls /data/input

# Ver contenido de un archivo
hdfs dfs -cat /data/input/Productos.csv | head -10

# Ver más comandos en: examples/01-hdfs-basics.md
```

### Ejecutar Consultas Hive

**Opción 1: Usando Hue (Recomendado - Interfaz Gráfica)**
```bash
# Abre tu navegador en:
http://localhost:8888

# Primera vez: crea usuario admin con tu contraseña
# Luego: Query > Editor > Hive
# Escribe tus consultas en el editor visual
```
Ver guía completa: [docs/GUIA-HUE.md](docs/GUIA-HUE.md)

**Opción 2: Usando beeline (Línea de Comandos)**
```bash
# Conectarse a HiveServer2
docker exec -it hive-server bash
beeline -u jdbc:hive2://localhost:10000

# Usar la base de datos
USE educacion_db;

# Ejecutar una consulta simple
SELECT * FROM productos LIMIT 10;

# Para salir:
!quit
```

Ver ejemplos completos en: [examples/02-hive-queries.sql](examples/02-hive-queries.sql)

### Detener el Entorno

```bash
# Detener todos los contenedores
docker-compose stop

# Detener y eliminar contenedores (los datos persisten)
docker-compose down

# Detener y eliminar TODO (incluyendo datos)
docker-compose down -v
```

## 📚 Ejemplos y Ejercicios

El repositorio incluye material didáctico progresivo:

1. **[01-hdfs-basics.md](examples/01-hdfs-basics.md)**
   - Comandos básicos de HDFS
   - Operaciones con archivos
   - Ejercicios prácticos

2. **[02-hive-queries.sql](examples/02-hive-queries.sql)**
   - Consultas HiveQL desde básicas hasta avanzadas
   - JOINs y subconsultas
   - Análisis de negocio

3. **[03-ejercicios-alumnos.md](examples/03-ejercicios-alumnos.md)**
   - Ejercicios prácticos con diferentes niveles de dificultad
   - Incluye pistas y desafíos

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                   Cliente (tú)                      │
│  - beeline (Hive CLI)                              │
│  - hdfs dfs (HDFS CLI)                             │
│  - Navegador Web (UIs)                             │
└────────────────┬────────────────────────────────────┘
                 │
    ┌────────────┴─────────────┐
    │                          │
┌───▼──────────┐      ┌────────▼────────┐
│  NameNode    │      │  HiveServer2    │
│  (HDFS Master│      │  (Query Engine) │
│   Puerto 9870│      │   Puerto 10000  │
└───┬──────────┘      └────────┬────────┘
    │                          │
┌───▼──────────┐      ┌────────▼────────┐
│  DataNode    │      │ Hive Metastore  │
│ (Almacenam.) │      │ (Metadatos)     │
└──────────────┘      └────────┬────────┘
                               │
                      ┌────────▼────────┐
                      │   PostgreSQL    │
                      │  (Persistencia) │
                      └─────────────────┘
```

## 📁 Estructura del Proyecto

```
hadoop-example/
├── data/                          # Datos CSV originales
│   ├── Clientes.csv
│   ├── Productos.csv
│   ├── Venta.csv
│   └── ...
├── scripts/                       # Scripts de inicialización
│   ├── init-hdfs.sh              # Configuración inicial de HDFS
│   ├── load-data.sh              # Carga de datos a HDFS
│   └── create-hive-tables.sql    # Creación de tablas Hive
├── examples/                      # Material educativo
│   ├── 01-hdfs-basics.md         # Guía de HDFS
│   ├── 02-hive-queries.sql       # Ejemplos de HiveQL
│   └── 03-ejercicios-alumnos.md  # Ejercicios prácticos
├── docs/                          # Documentación adicional
│   ├── GUIA-ALUMNO.md            # Guía para estudiantes
│   └── GUIA-PROFESOR.md          # Guía para el instructor
├── docker-compose.yml             # Configuración de servicios
├── hadoop.env                     # Variables de entorno
└── README.md                      # Este archivo
```

## 🌐 Interfaces Web

Una vez iniciado el entorno, accede a las siguientes URLs:

### Hue - Editor SQL y Browser HDFS
- **URL**: http://localhost:8888
- **Usuario**: admin (primera vez te pedirá crear contraseña)
- **Función**: Interfaz gráfica completa para:
  - Ejecutar consultas HiveQL con editor visual
  - Explorar archivos HDFS con navegador
  - Ver historial de queries
  - Visualizar resultados en tablas

### HDFS NameNode UI
- **URL**: http://localhost:9870
- **Función**: Explorar el sistema de archivos HDFS
- **Acceso**: `Utilities > Browse the file system`

### YARN ResourceManager UI
- **URL**: http://localhost:8088
- **Función**: Monitorear jobs y recursos del cluster

## 🔧 Solución de Problemas

### Error: "Puerto ya en uso"

```bash
# Ver qué proceso usa el puerto (ejemplo: 9870)
# Windows:
netstat -ano | findstr :9870

# Cambiar el puerto en docker-compose.yml
ports:
  - "9871:9870"  # Usar 9871 en lugar de 9870
```

### Los contenedores no inician

```bash
# Ver logs de un contenedor específico
docker logs namenode

# Ver logs en tiempo real
docker logs -f hive-server
```

### "Table not found" en Hive

```bash
# Verificar que estás en la base de datos correcta
USE educacion_db;
SHOW TABLES;

# Si no hay tablas, ejecuta nuevamente:
!run /scripts/create-hive-tables.sql
```

### Problemas de memoria

Si Docker se queda sin memoria:

1. Abre Docker Desktop
2. Ve a Settings > Resources
3. Aumenta la RAM a 6-8 GB
4. Reinicia Docker

### Limpiar y reiniciar desde cero

```bash
# Detener y eliminar TODO
docker-compose down -v

# Eliminar imágenes (opcional)
docker system prune -a

# Volver a iniciar
docker-compose up -d
```

## 📖 Recursos Adicionales

### Documentación Oficial

- [Apache Hadoop](https://hadoop.apache.org/docs/current/)
- [Apache Hive](https://hive.apache.org/)
- [HDFS Commands Guide](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)
- [HiveQL Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual)

### Tutoriales Recomendados

- [Hadoop Basics](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)
- [Hive Tutorial](https://cwiki.apache.org/confluence/display/Hive/Tutorial)

## 👥 Contribuciones

Si encuentras errores o tienes sugerencias:

1. Reporta un issue en GitHub
2. Envía un pull request
3. Contacta al instructor

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 🙋 Soporte

Para preguntas y soporte:
- Email: [tu-email]
- Issues: GitHub Issues
- Documentación: Ver carpeta `/docs`

---

**¡Feliz aprendizaje!** 🎓