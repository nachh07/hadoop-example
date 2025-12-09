# Guía 1: Operaciones Básicas con HDFS

## Introducción

HDFS (Hadoop Distributed File System) es el sistema de archivos distribuido de Hadoop. En esta guía aprenderás las operaciones fundamentales para trabajar con archivos en HDFS.

## Pre-requisitos

- Contenedores Docker ejecutándose (`docker-compose up -d`)
- Acceso al contenedor namenode

## Conectarse al NameNode

```bash
docker exec -it namenode bash
```

## Comandos Básicos de HDFS

### 1. Listar Archivos y Directorios

```bash
# Listar el directorio raíz
hdfs dfs -ls /

# Listar contenido del directorio de datos
hdfs dfs -ls /data/input

# Listar de forma recursiva
hdfs dfs -ls -R /data
```

**Ejercicio**: Lista todos los archivos CSV que se cargaron en `/data/input`

---

### 2. Ver Contenido de Archivos

```bash
# Ver las primeras líneas de un archivo
hdfs dfs -cat /data/input/Clientes.csv | head -20

# Ver solo el encabezado
hdfs dfs -cat /data/input/Productos.csv | head -1

# Buscar un cliente específico
hdfs dfs -cat /data/input/Clientes.csv | grep "Buenos Aires" | head -5
```

**Ejercicio**: Encuentra cuántos productos hay del tipo "INFORMATICA" en el archivo Productos.csv

---

### 3. Información sobre Archivos

```bash
# Ver tamaño de archivos
hdfs dfs -du -h /data/input

# Ver estadísticas de un archivo específico
hdfs dfs -stat "%n %o %r" /data/input/Venta.csv

# Contar líneas de un archivo
hdfs dfs -cat /data/input/Clientes.csv | wc -l
```

---

### 4. Copiar Archivos

```bash
# Copiar desde local a HDFS
hdfs dfs -put /ruta/local/archivo.txt /data/input/

# Copiar desde HDFS a local
hdfs dfs -get /data/input/Productos.csv /tmp/

# Copiar dentro de HDFS
hdfs dfs -cp /data/input/Clientes.csv /data/backup/
```

**Ejercicio**: Crea una copia del archivo Productos.csv en un nuevo directorio `/data/backup/`

---

### 5. Crear y Eliminar Directorios

```bash
# Crear un directorio
hdfs dfs -mkdir /data/procesados

# Crear directorios anidados
hdfs dfs -mkdir -p /data/año/mes/dia

# Eliminar un directorio vacío
hdfs dfs -rmdir /data/procesados

# Eliminar directorio con contenido
hdfs dfs -rm -r /data/año
```

---

### 6. Mover y Renombrar

```bash
# Mover archivo
hdfs dfs -mv /data/input/test.csv /data/procesados/

# Renombrar archivo
hdfs dfs -mv /data/input/old_name.csv /data/input/new_name.csv
```

---

### 7. Permisos y Propietarios

```bash
# Ver permisos detallados
hdfs dfs -ls -l /data/input

# Cambiar permisos (similar a chmod de Linux)
hdfs dfs -chmod 755 /data/input/Productos.csv

# Cambiar propietario
hdfs dfs -chown usuario:grupo /data/input/Productos.csv
```

---

### 8. Verificar Salud del Sistema

```bash
# Reporte del sistema HDFS
hdfs dfsadmin -report

# Ver DataNodes activos
hdfs dfsadmin -printTopology

# Verificar integridad de archivos
hdfs fsck /data/input -files -blocks -locations
```

---

## Ejercicios Prácticos

### Ejercicio 1: Exploración Básica
1. Lista todos los archivos en `/data/input`
2. Encuentra el tamaño total de todos los CSV
3. Identifica cuál es el archivo más grande

### Ejercicio 2: Manipulación de Datos
1. Crea un directorio `/data/mi_trabajo`
2. Copia el archivo Productos.csv a este directorio
3. Renómbralo a `productos_backup.csv`

### Ejercicio 3: Análisis Simple
1. Cuenta cuántas líneas tiene el archivo Venta.csv
2. Extrae solo el encabezado del archivo
3. Encuentra las primeras 5 ventas del archivo

---

## Interfaz Web de HDFS

Además de la línea de comandos, puedes explorar HDFS visualmente:

1. Abre tu navegador en `http://localhost:9870`
2. Ve a "Utilities" > "Browse the file system"
3. Navega a `/data/input` y explora los archivos

---

## Comandos de Ayuda

```bash
# Ver ayuda general de HDFS
hdfs dfs -help

# Ver ayuda de un comando específico
hdfs dfs -help ls
hdfs dfs -help cat
```

---

## Consejos y Buenas Prácticas

1. **Siempre verifica antes de eliminar**: Usa `ls` antes de `rm`
2. **Usa nombres descriptivos**: Organiza tus datos en directorios con nombres claros
3. **Aprovecha el factor de replicación**: En producción, HDFS replica datos automáticamente
4. **Monitorea el espacio**: Usa `du` regularmente para ver el uso de espacio

---

## Siguiente Paso

Una vez que domines estas operaciones básicas de HDFS, estarás listo para aprender HiveQL y realizar consultas SQL sobre estos datos.

Continúa con: [02-hive-queries.sql](./02-hive-queries.sql)
