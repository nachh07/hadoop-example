# Guía del Alumno - Entorno Hadoop

¡Bienvenido al laboratorio de Hadoop! Esta guía te ayudará a aprender Big Data de forma práctica.

## 🎯 Objetivos de Aprendizaje

Al completar este laboratorio, serás capaz de:

1. Entender la arquitectura de Hadoop y HDFS
2. Manipular archivos en un sistema de archivos distribuido
3. Ejecutar consultas SQL sobre grandes volúmenes de datos usando Hive
4. Analizar datos de negocio con HiveQL
5. Comprender conceptos de procesamiento distribuido

## 📚 Contenido del Laboratorio

### Módulo 1: Introducción a HDFS (2-3 horas)
- ¿Qué es HDFS y por qué se usa?
- Comandos básicos de línea de comandos
- Explorando datos en el sistema distribuido
- **Recurso**: [01-hdfs-basics.md](../examples/01-hdfs-basics.md)

### Módulo 2: HiveQL Básico (3-4 horas)
- SELECT, WHERE, ORDER BY
- Funciones de agregación (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY y HAVING
- **Recurso**: [02-hive-queries.sql](../examples/02-hive-queries.sql) (Nivel 1 y 2)

### Módulo 3: JOINs y Consultas Complejas (3-4 horas)
- INNER JOIN, LEFT JOIN
- Combinando múltiples tablas
- Subconsultas
- **Recurso**: [02-hive-queries.sql](../examples/02-hive-queries.sql) (Nivel 3 y 4)

### Módulo 4: Análisis de Datos Avanzado (4-5 horas)
- Análisis temporal
- Segmentación de clientes
- Métricas de negocio
- **Recurso**: [02-hive-queries.sql](../examples/02-hive-queries.sql) (Nivel 5)

### Módulo 5: Proyecto Final (Variable)
- Análisis completo de datos
- **Recurso**: [03-ejercicios-alumnos.md](../examples/03-ejercicios-alumnos.md)

## 🚀 Setup Inicial

### Pre-requisitos

Antes de comenzar, asegúrate de tener insta Docker Desktop:
- [Descargar Docker Desktop](https://www.docker.com/products/docker-desktop)
- RAM: Mínimo 8 GB
- Espacio en disco: ~5 GB libres

### Pasos de Instalación

**1. Obtén el repositorio**
```bash
# Si tienes Git instalado:
git clone https://github.com/tu-usuario/hadoop-example.git
cd hadoop-example

# O descarga el ZIP desde GitHub y extráelo
```

**2. Inicia el entorno**
```bash
docker-compose up -d
```

Esto tomará unos minutos la primera vez (descargando imágenes).

**3. Verifica que todo esté corriendo**
```bash
docker-compose ps
```

Deberías ver 6-7 contenedores en estado "Up".

**4. Carga inicial de datos**

Abre una terminal y ejecuta:

```bash
# Paso 1: Inicializar HDFS
docker exec -it namenode bash /scripts/init-hdfs.sh

# Paso 2: Cargar datos
docker exec -it namenode bash /scripts/load-data.sh

# Paso 3: Crear tablas Hive
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /scripts/create-hive-tables.sql
```

**5. Verifica la instalación**

Abre tu navegador:
- HDFS UI: http://localhost:9870
- YARN UI: http://localhost:8088

¡Listo! Ahora estás ready para empezar.

## 💻 Trabajando con el Entorno

### Conectarse a HDFS

```bash
docker exec -it namenode bash
```

Una vez dentro, puedes ejecutar comandos HDFS:

```bash
# Ver archivos
hdfs dfs -ls /data/input

# Ver contenido de un CSV
hdfs dfs -cat /data/input/Productos.csv | head -10
```

Para salir:
```bash
exit
```

### Conectarse a Hive

```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

Dentro de beeline:

```sql
-- Usar la base de datos
USE educacion_db;

-- Ver tablas
SHOW TABLES;

-- Ejecutar una consulta
SELECT * FROM Productos LIMIT 10;

-- Salir
!quit
```

## 📊 Datos Disponibles

El laboratorio incluye datos de un sistema de ventas con las siguientes tablas:

- **Clientes** (3,409 registros): Información de clientes
- **Productos** (293 registros): Catálogo de productos
- **Venta** (46,647 registros): Transacciones de venta
- **Empleados**: Personal de la empresa
- **Sucursales**: Ubicaciones de tiendas
- **Proveedores**: Proveedores de productos
- **Compra**: Historial de compras a proveedores
- **Gasto**: Gastos operativos
- **CanalDeVenta**: Canales de venta (Online, Tienda, etc.)
- **TiposDeGasto**: Categorías de gastos
- **Calendario**: Tabla dimensional de fechas

## 🎓 Metodología de Aprendizaje Sugerida

### 1. Aprender por Hacer
- Lee el concepto
- Ejecuta los ejemplos
- Intenta modificarlos
- Resuelve los ejercicios

### 2. Progresión Gradual
No te saltes niveles. Cada módulo construye sobre el anterior.

### 3. Toma Notas
Mantén un archivo `.sql` con tus consultas favoritas y aprendizajes.

###4. Pregunta
Si tienes dudas, no dudes en preguntar al instructor o buscar en la documentación oficial.

## 🏆 Mejores Prácticas

### Al Escribir Consultas

```sql
-- ✅ BUENO: Formateo claro y legible
SELECT 
    c.Nombre_y_Apellido,
    c.Provincia,
    SUM(v.Precio * v.Cantidad) as Total_Gastado
FROM Venta v
INNER JOIN Clientes c ON v.IdCliente = c.ID
GROUP BY c.Nombre_y_Apellido, c.Provincia
ORDER BY Total_Gastado DESC
LIMIT 10;

-- ❌ MALO: Todo en una línea, difícil de leer
SELECT c.Nombre_y_Apellido, c.Provincia, SUM(v.Precio * v.Cantidad) as Total_Gastado FROM Venta v INNER JOIN Clientes c ON v.IdCliente = c.ID GROUP BY c.Nombre_y_Apellido, c.Provincia ORDER BY Total_Gastado DESC LIMIT 10;
```

### Nomenclatura
- Usa nombres descriptivos para alias
- Prefieres minúsculas para nombres de columnas creadas
- Usa MAYÚSCULAS para palabras clave SQL

### Antes de Ejecutar
- Usa `LIMIT` cuando explores datos
- Comenta tus consultas complejas
- Guarda las consultas que funcionen

## 🐛 Solución de Problemas Comunes

### "No such table"
```sql
-- Solución: Verifica que estás en la base correcta
USE educacion_db;
SHOW TABLES;
```

### "Connection refused"
```bash
# Solución: Verifica que los contenedores estén corriendo
docker-compose ps
docker-compose up -d
```

### La consulta tarda mucho
- Limita los resultados con `LIMIT`
- Verifica que estés filtrando correctamente
- Recuerda que es un entorno de aprendizaje, no producción

### Necesito reiniciar todo
```bash
# Detener
docker-compose down

# Iniciar de nuevo
docker-compose up -d
```

## 📖 Recursos Adicionales

### Documentación
- [Apache Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual)
- [HDFS Commands](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)

### Cheat Sheets
- [HiveQL Quick Reference](https://hortonworks.com/wp-content/uploads/2016/05/Hortonworks.CheatSheet.SQLtoHive.pdf)

### Comunidad
- Stack Overflow: Busca `[hive]` o `[hdfs]`
- Foros de Apache Hive

## ✅ Checklist de Progreso

### Semana 1: Fundamentos
- [ ] Completé setup inicial
- [ ] Ejecuté todos los comandos básicos de HDFS
- [ ] Realicé consultas SELECT básicas
- [ ] Entiendo WHERE, ORDER BY, LIMIT

### Semana 2: Agregaciones y Combinaciones
- [ ] Domino COUNT, SUM, AVG, MIN, MAX
- [ ] Uso GROUP BY correctamente
- [ ] Entiendo INNER JOIN
- [ ] Puedo combinar 2-3 tablas

### Semana 3: Análisis Avanzado
- [ ] Uso subconsultas
- [ ] Trabajo con fechas
- [ ] Creo reportes de negocio
- [ ] Resuelvo problemas complejos

### Semana 4: Proyecto Final
- [ ] Definí un problema de análisis
- [ ] Diseñé las consultas necesarias
- [ ] Ejecuté y validé resultados
- [ ] Presenté hallazgos

## 🎉 Siguiente Nivel

Una vez que domines este laboratorio, podrás:
- Trabajar con clusters Hadoop reales
- Aprender Spark y procesamiento en memoria
- Explorar herramientas como Impala, Presto
- Implementar data warehouses en la nube (AWS EMR, Azure HDInsight)

---

**¡Mucho éxito en tu aprendizaje!** 🚀

Si tienes alguna pregunta, no dudes en consultar con tu instructor.
