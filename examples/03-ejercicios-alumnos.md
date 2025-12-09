# Ejercicios Prácticos de HiveQL

## Instrucciones

Estos ejercicios están diseñados para que practiques las consultas HiveQL aprendidas. Intenta resolverlos por tu cuenta antes de ver las respuestas.

**Conexión a Hive:**
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

Luego ejecuta:
```sql
USE educacion_db;
```

---

## Ejercicio 1: Consultas Básicas (★☆☆)

### 1.1 Productos Caros
Encuentra todos los productos que cuestan más de $2000.

**Columnas a mostrar**: Concepto, Tipo, Precio

<details>
<summary>💡 Pista</summary>
Usa WHERE con una condición simple de comparación
</details>

---

### 1.2 Productos de Impresión
Lista todos los productos del tipo 'IMPRESIÓN' ordenados por precio de mayor a menor.

**Columnas a mostrar**: Concepto, Precio

<details>
<summary>💡 Pista</summary>
Combina WHERE para filtrar y ORDER BY para ordenar
</details>

---

### 1.3 Búsqueda de Mochilas
Encuentra todos los productos cuyo concepto contenga la palabra "MOCHILA".

**Columnas a mostrar**: Concepto, Tipo, Precio

<details>
<summary>💡 Pista</summary>
Usa el operador LIKE con el patrón correcto
</details>

---

## Ejercicio 2: Agregaciones (★★☆)

### 2.1 Estadísticas por Tipo
Calcula para cada tipo de producto:
- Cantidad de productos
- Precio promedio
- Precio mínimo
- Precio máximo

Ordena por precio promedio descendente.

<details>
<summary>💡 Pista</summary>
Usa GROUP BY con funciones de agregación: COUNT, AVG, MIN, MAX
</details>

---

### 2.2 Clientes por Provincia
¿Cuántos clientes hay en cada provincia? Muestra solo las provincias con más de 100 clientes.

**Columnas a mostrar**: Provincia, Total_Clientes

<details>
<summary>💡 Pista</summary>
GROUP BY con HAVING para filtrar grupos
</details>

---

### 2.3 Distribución de Edades
Calcula la edad promedio de los clientes por provincia. Ordena por edad promedio descendente.

<details>
<summary>💡 Pista</summary>
Usa AVG(Edad) y recuerda manejar valores NULL
</details>

---

## Ejercicio 3: JOINs (★★☆)

### 3.1 Detalle de Ventas
Crea un reporte que muestre:
- IdVenta
- Fecha de venta
- Nombre del cliente
- Nombre del producto
- Cantidad vendida
- Precio unitario
- Total (Cantidad * Precio)

Limita a 30 registros.

<details>
<summary>💡 Pista</summary>
Necesitas JOIN entre Venta, Clientes y Productos
</details>

---

### 3.2 Top 5 Productos Más Vendidos
Muestra los 5 productos más vendidos (por cantidad de unidades).

**Columnas a mostrar**: Concepto, Tipo, Total_Unidades_Vendidas, Numero_De_Ventas

<details>
<summary>💡 Pista</summary>
JOIN Venta con Productos, luega GROUP BY y ORDER BY con LIMIT
</details>

---

### 3.3 Productos Sin Ventas
Encuentra productos que nunca se han vendido.

**Columnas a mostrar**: Concepto, Tipo, Precio

<details>
<summary>💡 Pista</summary>
Usa LEFT JOIN y busca donde el IdVenta sea NULL
</details>

---

## Ejercicio 4: Análisis Temporal (★★★)

### 4.1 Ventas Mensuales 2019
Crea un reporte de ventas por mes para el año 2019:
- Mes (numérico)
- Cantidad de ventas
- Total de unidades vendidas
- Ingresos totales

<details>
<summary>💡 Pista</summary>
Usa YEAR() y MONTH() para extraer componentes de fecha
</details>

---

### 4.2 Tendencia Trimestral
Agrupa las ventas por trimestre y año. Muestra:
- Año
- Trimestre
- Total de ventas
- Ingresos totales

<details>
<summary>💡 Pista</summary>
Investiga la función QUARTER() en Hive
</details>

---

## Ejercicio 5: Análisis de Negocio (★★★)

### 5.1 Segmentación de Clientes
Clasifica a los clientes según su gasto total:
- 'VIP' si gastaron más de $50,000
- 'Premium' si gastaron entre $20,000 y $50,000
- 'Regular' si gastaron menos de $20,000

Muestra: Nombre, Provincia, Gasto_Total, Segmento

<details>
<summary>💡 Pista</summary>
Usa CASE dentro del SELECT después del JOIN y GROUP BY
</details>

---

### 5.2 Productos Complementarios
Para los productos del tipo 'INFORMATICA', encuentra:
- Producto
- Precio
- Cuántas veces se vendió junto con productos de tipo 'AUDIO' (en el mismo mes)

Este es un ejercicio avanzado que requiere pensar en la estructura de múltiples JOINs.

<details>
<summary>💡 Pista</summary>
Necesitarás un self-join de la tabla Venta para encontrar ventas relacionadas
</details>

---

### 5.3 Análisis de Retención
Encuentra clientes que:
1. Hicieron su primera compra en 2018
2. Y también compraron en 2019

Muestra: Nombre, Primera_Compra, Ultima_Compra, Total_Compras

<details>
<summary>💡 Pista</summary>
Usa subconsultas para filtrar por año en diferentes condiciones
</details>

---

## Ejercicio 6: Optimización y Performance (★★★)

### 6.1 Query Plan
Ejecuta una de tus consultas anteriores con `EXPLAIN` adelante:

```sql
EXPLAIN SELECT ...
```

Intenta interpretar el plan de ejecución.

---

### 6.2 Particiones
Investiga cómo crear una tabla particionada por año de venta. Escribe el DDL (CREATE TABLE) sin ejecutarlo.

---

## Desafío Final (★★★★)

### Dashboard Ejecutivo
Crea una consulta única que genere un reporte ejecutivo con:
1. Total de ventas del último año
2. Producto más vendido
3. Provincia con más clientes activos
4. Ingreso promedio por cliente
5. Tasa de crecimiento vs año anterior (si es posible)

Este reporte debe ser útil para una presentación ejecutiva.

---

## Entrega

Guarda tus consultas en un archivo `.sql` y compártelo con el profesor. Incluye:
- El número del ejercicio
- La consulta SQL
- Una captura o explicación del resultado

---

## Respuestas

Las respuestas a estos ejercicios están disponibles en el archivo `03-ejercicios-respuestas.sql`.

**¡No hagas trampa!** Intenta resolver todos los ejercicios primero. 😊
