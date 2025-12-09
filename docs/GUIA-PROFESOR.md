# Guía del Profesor - Entorno Hadoop

Esta guía está diseñada para ayudarte a facilitar el laboratorio de Hadoop de manera efectiva.

## 📋 Resumen Ejecutivo

Este entorno proporciona:
- **Plataforma completa**: HDFS + Hive + YARN en Docker
- **Datos realistas**: ~50K registros de ventas con 10+ tablas relacionadas
- **Material progresivo**: De comandos básicos a análisis de negocio
- **Tiempo estimado**: 15-20 horas de contenido total

## 🎯 Objetivos de Aprendizaje

### Conocimientos Fundamentales
- Arquitectura de Hadoop y sistemas distribuidos
- HDFS como sistema de archivos distribuido
- Hive como motor SQL sobre Big Data
- Diferencias entre RDBMS tradicional y Hadoop

### Habilidades Prácticas
- Manipulación de archivos en HDFS
- Escritura de consultas HiveQL
- Análisis de datos a escala
- Resolución de problemas en entornos distribuidos

## 📚 Estructura del Curso

### Módulo 1: Fundamentos de HDFS (2-3 horas)

**Conceptos Clave:**
- ¿Por qué HDFS? Problemas que resuelve
- Arquitectura NameNode/DataNode
- Factor de replicación
- Write-once, read-many

**Actividades:**
1. Demostración en vivo de comandos HDFS
2. Ejercicios guiados ([01-hdfs-basics.md](../examples/01-hdfs-basics.md))
3. Exploración de la interfaz web (http://localhost:9870)

**Puntos de Enseñanza:**
- HDFS está optimizado para archivos grandes, no pequeños
- No es un reemplazo de sistemas de archivos tradicionales
- La distribución de datos es transparente para el usuario

**Evaluación:**
- ¿Pueden crear directorios y copiar archivos?
- ¿Entienden la diferencia entre almacenamiento local y HDFS?

---

### Módulo 2: HiveQL Nivel Básico (3-4 horas)

**Conceptos Clave:**
- Hive como abstracción SQL sobre HDFS
- Tablas externas vs tablas gestionadas
- Metastore y su función
- Diferencias con SQL tradicional

**Actividades:**
1. SELECT básico y filtros WHERE
2. Ordenamiento y limitación de resultados
3. Búsqueda con LIKE
4. Primeros ejercicios ([02-hive-queries.sql](../examples/02-hive-queries.sql) Nivel 1)

**Demostración en Vivo - Script Sugerido:**
```sql
-- Mostrar que Hive funciona como SQL normal
SELECT * FROM Productos LIMIT 5;

-- Explicar que detrás de escena está leyendo desde HDFS
-- (Mostrar en la UI de HDFS)

-- Demostrar filtrado
SELECT Concepto, Precio
FROM Productos
WHERE Tipo = 'INFORMATICA'
ORDER BY Precio DESC
LIMIT 10;

-- Preguntar: "¿Qué productos de audio hay?"
-- Dejar que los alumnos lo resuelvan
```

**Errores Comunes de Alumnos:**
- Olvidar el `USE educacion_db;`
- No usar `LIMIT` en exploraciones
- Confundir `=` con `==`

---

### Módulo 3: Agregaciones y GROUP BY (3 horas)

**Conceptos Clave:**
- Funciones de agregación (COUNT, SUM, AVG, MIN, MAX)
- Importancia de GROUP BY en Big Data
- HAVING vs WHERE

**Actividades:**
1. Estadísticas por categoría
2. Análisis demográfico de clientes
3. Ejercicios ([02-hive-queries.sql](../examples/02-hive-queries.sql) Nivel 2)

**Ejemplo para Explicar Conceptos:**
```sql
-- ❌ Error común: olvidar GROUP BY
SELECT Tipo, COUNT(*) FROM Productos; -- Falla

-- ✅ Correcto
SELECT Tipo, COUNT(*) FROM Productos GROUP BY Tipo;

-- Explicar: si agrupas por una columna, 
-- TODAS las columnas no agregadas deben estar en GROUP BY
```

**Ejercicio En Clase:**
"Encuentra la edad promedio de clientes por provincia. ¿Qué provincia tiene los clientes más jóvenes?"

---

### Módulo 4: JOINs (4-5 horas)

**Conceptos Clave:**
- Por qué necesitamos JOINs en datos distribuidos
- INNER JOIN, LEFT JOIN, RIGHT JOIN
- Performance de JOINs en Hive
- Estrategias de optimización

**Actividades:**
1. JOIN simple: Ventas + Productos
2. JOIN múltiple: Ventas + Productos + Clientes
3. Análisis de ventas por región
4. Ejercicios ([02-hive-queries.sql](../examples/02-hive-queries.sql) Nivel 3)

**Demostración - Construcción Gradual:**
```sql
-- Paso 1: Solo Ventas
SELECT IdVenta, Fecha, IdProducto, Precio 
FROM Venta 
LIMIT 5;

-- Paso 2: Agregar nombre del producto
SELECT 
    v.IdVenta,
    v.Fecha,
    p.Concepto,  -- ¡Ahora tenemos el nombre!
    v.Precio
FROM Venta v
INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 5;

-- Paso 3: Agregar cliente
SELECT 
    v.IdVenta,
    v.Fecha,
    c.Nombre_y_Apellido,  -- Cliente
    p.Concepto,          -- Producto
    v.Precio
FROM Venta v
INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
INNER JOIN Clientes c ON v.IdCliente = c.ID
LIMIT 5;
```

**Discusión en Clase:**
"¿Qué pasa si hacemos LEFT JOIN vs INNER JOIN? ¿Cuándo usarías cada uno?"

---

### Módulo 5: Análisis Avanzado (4-5 horas)

**Conceptos Clave:**
- Subconsultas y CTEs
- Funciones de fecha y tiempo
- CASE statements
- Window functions (si el tiempo permite)

**Proyecto Guiado: Dashboard Ejecutivo**

Construir juntos un reporte que responda:
1. ¿Cuáles son los productos más rentables?
2. ¿Qué provincias generan más ingresos?
3. ¿Cuál es la tendencia de ventas mensual?
4. ¿Quiénes son los clientes VIP?

```sql
-- Ejemplo: Clasificación de Clientes
SELECT 
    c.Nombre_y_Apellido,
    SUM(v.Precio * v.Cantidad) as Total_Gastado,
    CASE 
        WHEN SUM(v.Precio * v.Cantidad) > 50000 THEN 'VIP'
        WHEN SUM(v.Precio * v.Cantidad) > 20000 THEN 'Premium'
        ELSE 'Regular'
    END as Segmento
FROM Venta v
INNER JOIN Clientes c ON v.IdCliente = c.ID
GROUP BY c.Nombre_y_Apellido
ORDER BY Total_Gastado DESC
LIMIT 20;
```

---

## 🎪 Dinámicas de Clase Sugeridas

### Warm-up (10 min inicio de clase)
Pregunta rápida del día:
- "¿Cuántos productos hay en total?"
- "¿Cuál es el cliente con ID 100?"
- "¿Qué tipos de productos hay?"

### Pair Programming (30 min)
Por parejas, resolver un ejercicio mediano:
- Uno escribe la consulta
- El otro revisa y sugiere
- Rotan roles

### Code Review Colaborativo (20 min)
- Proyecta la pantalla
- Alumno voluntario resuelve en vivo
- Clase comenta y mejora la solución

### Challenge del Día (Variable)
Último 15-20 min de clase:
- Ejercicio más complejo
- Primer equipo en resolverlo correctamente gana
- Fomenta competencia sana

## 📊 Evaluación Sugerida

### Quiz Rápido (10% de nota final)
5-7 preguntas de opción múltiple sobre:
- Conceptos de HDFS
- Sintaxis HiveQL
- Diferencias Hive vs SQL tradicional

### Ejercicios Prácticos (40%)
Resolución de los ejercicios en [03-ejercicios-alumnos.md](../examples/03-ejercicios-alumnos.md)

Criterios:
- Correctitud de la consulta (60%)
- Calidad del código (formateo, nombres) (20%)
- Explicación del razonamiento (20%)

### Proyecto Final (50%)
**Opción A: Análisis Exploratorio**
Elegir un foco:
- Análisis de productos
- Comportamiento de clientes
- Tendencias temporales

Entregar:
- 10-15 consultas SQL con explicación
- Insights encontrados
- Visualizaciones (opcional, pueden usar cualquier herramienta)

**Opción B: Dashboard Ejecutivo**
Crear un conjunto de consultas que respondan:
- KPIs de negocio
- Comparativas (mes a mes, año a año)
- Segmentaciones
- Recomendaciones basadas en datos

## 🎯 Respuestas a Ejercicios Principales

### Ejercicio 1.1: Productos Caros
```sql
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE Precio > 2000
ORDER BY Precio DESC;
```

### Ejercicio 2.1: Estadísticas por Tipo
```sql
SELECT 
    Tipo,
    COUNT(*) as Cantidad_Productos,
    ROUND(AVG(Precio), 2) as Precio_Promedio,
    MIN(Precio) as Precio_Minimo,
    MAX(Precio) as Precio_Maximo
FROM Productos
GROUP BY Tipo
ORDER BY Precio_Promedio DESC;
```

### Ejercicio 3.1: Detalle de Ventas
```sql
SELECT 
    v.IdVenta,
    v.Fecha,
    c.Nombre_y_Apellido,
    p.Concepto,
    v.Cantidad,
    v.Precio,
    (v.Cantidad * v.Precio) as Total
FROM Venta v
INNER JOIN Clientes c ON v.IdCliente = c.ID
INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 30;
```

### Ejercicio 3.2: Top 5 Productos
```sql
SELECT 
    p.Concepto,
    p.Tipo,
    SUM(v.Cantidad) as Total_Unidades_Vendidas,
    COUNT(v.IdVenta) as Numero_De_Ventas
FROM Venta v
INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
GROUP BY p.Concepto, p.Tipo
ORDER BY Total_Unidades_Vendidas DESC
LIMIT 5;
```

### Ejercicio 5.1: Segmentación de Clientes
```sql
SELECT 
    c.Nombre_y_Apellido,
    c.Provincia,
    SUM(v.Cantidad * v.Precio) as Gasto_Total,
    CASE 
        WHEN SUM(v.Cantidad * v.Precio) > 50000 THEN 'VIP'
        WHEN SUM(v.Cantidad * v.Precio) > 20000 THEN 'Premium'
        ELSE 'Regular'
    END as Segmento
FROM Venta v
INNER JOIN Clientes c ON v.IdCliente = c.ID
GROUP BY c.Nombre_y_Apellido, c.Provincia
ORDER BY Gasto_Total DESC;
```

## 🐛 Problemas Comunes y Soluciones

### "beeline no conecta"
```bash
# Verificar que hive-server esté corriendo
docker ps | grep hive-server

# Reiniciar si es necesario
docker-compose restart hive-server

# Esperar 30-60 segundos y volver a intentar
```

### Consultas muy lentas
- Recuerda que es un entorno de desarrollo, no producción
- Usa `LIMIT` generosamente
- Considera aumentar recursos de Docker (Settings > Resources > 8GB RAM)

### Datos se perdieron después de reiniciar
```bash
# Si usaste docker-compose down -v, eliminas los volúmenes
# Para preservar datos, usa:
docker-compose down  # Sin -v

# Para volver a cargar datos:
docker exec -it namenode bash /scripts/load-data.sh
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f /scripts/create-hive-tables.sql
```

## 💡 Tips de Enseñanza

###1. Usa Analogías
- HDFS = "Biblioteca distribuida"
- NameNode = "Catálogo de la biblioteca"
- DataNodes = "Estantes en diferentes ubicaciones"

### 2. Muestra el "Por Qué"
No solo enseñes sintaxis, explica:
- ¿Por qué existe Hadoop?
- ¿Qué problemas resuelve?
- ¿Cuándo NO usarlo?

### 3. Fomenta la Experimentación
- "¿Qué pasa si...?"
- "¿Cómo harías para...?"
- No penalices errores, son oportunidades de aprendizaje

### 4. Contextualiza
Usa ejemplos de negocio reales:
- "Amazon analiza millones de ventas así"
- "Netflix usa queries similares para recomendar películas"

## 📅 Plan de Clase Sugerido (5 Sesiones)

### Sesión 1 (3 horas): Setup y HDFS
- 0:00-0:30: Introducción teórica a Big Data
- 0:30-1:30: Setup del entorno + HDFS basics
- 1:30-2:00: Break
- 2:00-3:00: Ejercicios HDFS + Q&A

### Sesión 2 (3 horas): HiveQL Básico
- 0:00-0:45: Intro a Hive + Primeras query
- 0:45-1:30: WHERE, ORDER BY, LIKE
- 1:30-2:00: Break
- 2:00-3:00: Ejercicios nivel 1

### Sesión 3 (3 horas): Agregaciones
- 0:00-1:00: COUNT, SUM, AVG, GROUP BY
- 1:00-1:15: Break
- 1:15-2:00: Pair programming
- 2:00-3:00: Ejercicios nivel 2

### Sesión 4 (4 horas): JOINs
- 0:00-1:00: Teoría y demo de JOINs
- 1:00-2:00: Ejercicios guiados
- 2:00-2:15: Break
- 2:15-3:00: Ejercicios nivel 3
- 3:00-4:00: Code review colaborativo

### Sesión 5 (4 horas): Proyecto Final
- 0:00-0:30: Presentación del proyecto
- 0:30-3:00: Trabajo en proyecto (con apoyo)
- 3:00-4:00: Presentaciones cortas + Cierre

## 📈 Variaciones del Contenido

### Si tienes MÁS tiempo:
- Agrega módulo de optimización de queries
- Introduce particiones en Hive
- Enseña sobre formatos de archivo (Parquet, ORC)
- Muestra Spark como evolución

### Si tienes MENOS tiempo:
- Combina módulos 1-2 en una sesión
- Reduce ejercicios a solo los esenciales
- Asigna lectura previa (README)
- Focus en JOINs y análisis, menos en HDFS

### Para Nivel Avanzado:
- Window functions
- User-Defined Functions (UDFs)
- Tuning y optimización
- Integración con BI tools

---

**¡Éxito con tu clase!** 🎓

Si tienes dudas o sugerencias para mejorar este material, no dudes en contribuir.
