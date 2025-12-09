# Comandos Rápidos - Hadoop Environment

## 🛑 Detener los Servicios

### Opción 1: Detener (mantiene los datos)
```bash
docker-compose stop
```
Los contenedores se detienen pero los volúmenes (datos) persisten.

### Opción 2: Detener y eliminar contenedores (mantiene los datos)
```bash
docker-compose down
```
Elimina contenedores pero los volúmenes persisten. **Recomendado para limpieza.**

### Opción 3: Eliminar TODO (incluyendo datos)
```bash
docker-compose down -v
```
⚠️ **CUIDADO**: Esto elimina TODOS los datos. Tendrás que volver a cargar los CSV.

---

## 🚀 Iniciar Todo desde Cero

### Paso 1: Iniciar los Contenedores
```bash
cd "c:\Users\SID\Documents\Educacion IT\repos\hadoop-example"
docker-compose up -d
```
Resultado esperado: 8 contenedores iniciando

### Paso 2: Esperar (1-2 minutos)
Espera a que todos los servicios estén listos.

Verificar estado:
```bash
docker-compose ps
```
Todos deben estar "Up" y "healthy"

### Paso 3: Inicializar HDFS
```bash
docker exec namenode bash /scripts/init-hdfs.sh
```
Resultado esperado:
```
✓ HDFS está disponible
✓ Directorios creados exitosamente
```

### Paso 4: Cargar Datos CSV
```bash
docker exec namenode bash /scripts/load-data.sh
```
Resultado esperado:
```
✓ 13 archivos cargados
```

### Paso 5: Mover Archivos a Subdirectorios
```bash
docker exec namenode bash -c "hdfs dfs -mv /data/input/Clientes.csv /data/input/clientes/ && hdfs dfs -mv /data/input/Productos.csv /data/input/productos/ && hdfs dfs -mv /data/input/Venta.csv /data/input/venta/ && hdfs dfs -mv /data/input/Empleados.csv /data/input/empleados/ && hdfs dfs -mv /data/input/Sucursales.csv /data/input/sucursales/ && hdfs dfs -mv /data/input/CanalDeVenta.csv /data/input/canal/ && hdfs dfs -mv /data/input/Compra.csv /data/input/compra/ && hdfs dfs -mv /data/input/Proveedores.csv /data/input/proveedores/ && hdfs dfs -mv /data/input/Gasto.csv /data/input/gasto/ && hdfs dfs -mv /data/input/TiposDeGasto.csv /data/input/tiposgasto/ && hdfs dfs -mv /data/input/Calendario.csv /data/input/calendario/"
```

### Paso 6: Crear Tablas Hive
```bash
docker exec hive-server beeline -u jdbc:hive2://localhost:10000 -f /scripts/create-hive-tables.sql
```
Resultado esperado:
```
11 rows selected (lista de tablas)
```

### Paso 7: Crear Usuario Admin en Hue
Abre: http://localhost:8888

Primera vez:
- Usuario: `admin`
- Password: `admin`
- Email: `admin@localhost`

¡Listo! Ya puedes usar el entorno.

---

## 📊 Acceder a las Interfaces

| Servicio | URL | Uso |
|----------|-----|-----|
| **Hue** | http://localhost:8888 | Editor SQL visual (RECOMENDADO) |
| **HDFS UI** | http://localhost:9870 | Ver archivos en HDFS |
| **YARN UI** | http://localhost:8088 | Ver jobs ejecutándose |

---

## 🔄 Reiniciar Todo (sin perder datos)

Si algo falla o quieres empezar de nuevo SIN perder datos:

```bash
# Paso 1: Detener
docker-compose down

# Paso 2: Iniciar
docker-compose up -d

# Paso 3: Esperar 1-2 minutos

# Paso 4: Verificar
docker-compose ps
```

Los datos ya están cargados, no necesitas repetir los pasos 3-6.

---

## 💻 Ejecutar Consultas

### Opción A: Usando Hue (Recomendado)
1. Abre http://localhost:8888
2. Query > Editor > Hive
3. Escribe tu query:
   ```sql
   USE educacion_db;
   SELECT * FROM productos LIMIT 10;
   ```
4. Presiona Execute (▶️)

### Opción B: Usando beeline (Terminal)
```bash
# Conectarse
docker exec -it hive-server bash
beeline -u jdbc:hive2://localhost:10000

# Dentro de beeline:
USE educacion_db;
SELECT * FROM productos LIMIT 5;

# Salir
!quit
exit
```

### Opción C: Query directa (una línea)
```bash
docker exec hive-server beeline -u jdbc:hive2://localhost:10000 -e "USE educacion_db; SELECT COUNT(*) FROM clientes;"
```

---

## 🔍 Comandos Útiles de Diagnóstico

### Ver logs de un servicio
```bash
docker logs hive-server --tail 50
docker logs namenode --tail 50
docker logs hue --tail 50
```

### Ver estado de HDFS
```bash
docker exec namenode hdfs dfsadmin -report
```

### Listar archivos en HDFS
```bash
docker exec namenode hdfs dfs -ls /data/input
```

### Ver bases de datos en Hive
```bash
docker exec hive-server beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;"
```

### Reiniciar un solo servicio
```bash
docker-compose restart hue
docker-compose restart hive-server
```

---

## 📚 Ejemplos de Consultas

### Básica
```sql
USE educacion_db;
SELECT Concepto, Tipo, Precio 
FROM productos 
WHERE Tipo = 'INFORMATICA' 
LIMIT 10;
```

### Con Agregación
```sql
SELECT Tipo, COUNT(*) as Total, AVG(Precio) as Promedio
FROM productos
GROUP BY Tipo
ORDER BY Total DESC;
```

### Con JOIN
```sql
SELECT 
    v.IdVenta,
    p.Concepto,
    v.Precio,
    v.Cantidad,
    (v.Precio * v.Cantidad) as Total
FROM venta v
INNER JOIN productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 20;
```

Ver más ejemplos en: `examples/02-hive-queries.sql`

---

## 🎓 Para la Clase

### Setup para Alumnos
Comparte con tus alumnos:
1. El repositorio
2. `README.md` para instalación
3. `docs/GUIA-ALUMNO.md` para aprender

### Material de Clase
- `examples/01-hdfs-basics.md` - Comandos HDFS
- `examples/02-hive-queries.sql` - Queries progresivas
- `examples/03-ejercicios-alumnos.md` - Ejercicios
- `docs/GUIA-PROFESOR.md` - Plan de clase

---

## ⚠️ Troubleshooting

### "No such container"
```bash
docker-compose up -d
```

### "Port already in use"
Cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "8889:8888"  # Cambiar 8888 a 8889
```

### "Database is locked" en Hue
Ya está resuelto, usamos PostgreSQL. Si persiste, reinicia:
```bash
docker-compose restart hue
```

### Hive no muestra datos
Verifica que los archivos estén en sus subdirectorios:
```bash
docker exec namenode hdfs dfs -ls /data/input/productos/
```

---

## 📋 Checklist Rápido

Antes de la clase, verifica:
- [ ] `docker-compose ps` - Todos Up
- [ ] http://localhost:8888 - Hue accesible
- [ ] http://localhost:9870 - HDFS UI accesible
- [ ] Query de prueba funciona en Hue
- [ ] Alumnos tienen Docker instalado

---

**¡Listo para enseñar Big Data!** 🚀
