-- ================================================
-- Guía 2: Consultas HiveQL - De Básico a Avanzado
-- Base de Datos: educacion_db
-- ================================================

-- Primero, asegúrate de estar usando la base de datos correcta
USE educacion_db;

-- Ver todas las tablas disponibles
SHOW TABLES;

-- ================================================
-- NIVEL 1: CONSULTAS BÁSICAS
-- ================================================

-- 1.1 SELECT simple - Ver todos los registros (limitado)
SELECT * FROM Productos LIMIT 10;

-- 1.2 SELECT con columnas específicas
SELECT Concepto, Tipo, Precio FROM Productos LIMIT 20;

-- 1.3 WHERE - Filtrar por condición
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE
    Tipo = 'INFORMATICA';

-- 1.4 WHERE con múltiples condiciones (AND)
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE
    Tipo = 'INFORMATICA'
    AND Precio > 1000;

-- 1.5 WHERE con OR
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE
    Tipo = 'AUDIO'
    OR Tipo = 'GAMING';

-- 1.6 WHERE con BETWEEN
SELECT Concepto, Precio
FROM Productos
WHERE
    Precio BETWEEN 500 AND 1000;

-- 1.7 WHERE con IN
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE
    Tipo IN ('AUDIO', 'GAMING', 'BASES');

-- 1.8 WHERE con LIKE (búsqueda de patrones)
SELECT Concepto, Tipo, Precio
FROM Productos
WHERE
    Concepto LIKE '%NOTEBOOK%';

-- 1.9 ORDER BY - Ordenar resultados
SELECT Concepto, Precio
FROM Productos
WHERE
    Tipo = 'INFORMATICA'
ORDER BY Precio DESC
LIMIT 10;

-- 1.10 DISTINCT - Valores únicos
SELECT DISTINCT Tipo FROM Productos;

-- ================================================
-- NIVEL 2: FUNCIONES DE AGREGACIÓN
-- ================================================

-- 2.1 COUNT - Contar registros
SELECT COUNT(*) as Total_Productos FROM Productos;

-- 2.2 COUNT con condición
SELECT COUNT(*) as Total_Informatica
FROM Productos
WHERE
    Tipo = 'INFORMATICA';

-- 2.3 SUM - Sumar valores
SELECT SUM(Cantidad) as Total_Unidades_Vendidas FROM Venta;

-- 2.4 AVG - Promedio
SELECT AVG(Precio) as Precio_Promedio
FROM Productos
WHERE
    Tipo = 'AUDIO';

-- 2.5 MIN y MAX
SELECT
    MIN(Precio) as Precio_Minimo,
    MAX(Precio) as Precio_Maximo,
    AVG(Precio) as Precio_Promedio
FROM Productos
WHERE
    Tipo = 'INFORMATICA';

-- 2.6 GROUP BY - Agrupar resultados
SELECT
    Tipo,
    COUNT(*) as Cantidad_Productos,
    AVG(Precio) as Precio_Promedio
FROM Productos
GROUP BY
    Tipo;

-- 2.7 GROUP BY con HAVING (filtrar grupos)
SELECT Tipo, COUNT(*) as Cantidad, AVG(Precio) as Promedio
FROM Productos
GROUP BY
    Tipo
HAVING
    COUNT(*) > 10;

-- 2.8 Análisis por provincia (Clientes)
SELECT
    Provincia,
    COUNT(*) as Total_Clientes,
    ROUND(AVG(Edad), 2) as Edad_Promedio
FROM Clientes
WHERE
    Provincia IS NOT NULL
GROUP BY
    Provincia
ORDER BY Total_Clientes DESC
LIMIT 10;

-- ================================================
-- NIVEL 3: JOINS (Combinar Tablas)
-- ================================================

-- 3.1 INNER JOIN simple - Ventas con información de productos
SELECT v.IdVenta, v.Fecha, p.Concepto, p.Tipo, v.Cantidad, v.Precio
FROM Venta v
    INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 20;

-- 3.2 JOIN con agregación - Ventas totales por tipo de producto
SELECT
    p.Tipo,
    COUNT(v.IdVenta) as Total_Ventas,
    SUM(v.Cantidad) as Unidades_Vendidas,
    ROUND(SUM(v.Precio * v.Cantidad), 2) as Ingresos_Totales
FROM Venta v
    INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
GROUP BY
    p.Tipo
ORDER BY Ingresos_Totales DESC;

-- 3.3 JOIN múltiple - Venta con Cliente y Producto
SELECT v.IdVenta, v.Fecha, c.Nombre_y_Apellido, c.Provincia, p.Concepto, p.Tipo, v.Cantidad, v.Precio, (v.Cantidad * v.Precio) as Total
FROM
    Venta v
    INNER JOIN Clientes c ON v.IdCliente = c.ID
    INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 50;

-- 3.4 Ventas por provincia
SELECT
    c.Provincia,
    COUNT(v.IdVenta) as Total_Ventas,
    SUM(v.Cantidad * v.Precio) as Ingresos_Totales
FROM Venta v
    INNER JOIN Clientes c ON v.IdCliente = c.ID
WHERE
    c.Provincia IS NOT NULL
GROUP BY
    c.Provincia
ORDER BY Ingresos_Totales DESC;

-- 3.5 Top 10 clientes con más compras
SELECT
    c.Nombre_y_Apellido,
    c.Provincia,
    COUNT(v.IdVenta) as Total_Compras,
    SUM(v.Cantidad) as Total_Productos,
    ROUND(SUM(v.Cantidad * v.Precio), 2) as Gasto_Total
FROM Venta v
    INNER JOIN Clientes c ON v.IdCliente = c.ID
GROUP BY
    c.Nombre_y_Apellido,
    c.Provincia
ORDER BY Gasto_Total DESC
LIMIT 10;

-- ================================================
-- NIVEL 4: SUBCONSULTAS Y ANÁLISIS AVANZADO
-- ================================================

-- 4.1 Subconsulta en WHERE
SELECT Concepto, Precio
FROM Productos
WHERE
    Precio > (
        SELECT AVG(Precio)
        FROM Productos
    );

-- 4.2 Productos más caros que el promedio de su categoría
SELECT p1.Concepto, p1.Tipo, p1.Precio
FROM Productos p1
WHERE
    p1.Precio > (
        SELECT AVG(p2.Precio)
        FROM Productos p2
        WHERE
            p2.Tipo = p1.Tipo
    )
ORDER BY p1.Tipo, p1.Precio DESC;

-- 4.3 TOP productos más vendidos
SELECT
    p.Concepto,
    p.Tipo,
    SUM(v.Cantidad) as Total_Vendido,
    COUNT(v.IdVenta) as Num_Ventas
FROM Venta v
    INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
GROUP BY
    p.Concepto,
    p.Tipo
ORDER BY Total_Vendido DESC
LIMIT 20;

-- 4.4 Análisis temporal - Ventas por año
SELECT
    YEAR (v.Fecha) as Anio,
    COUNT(v.IdVenta) as Total_Ventas,
    SUM(v.Cantidad) as Unidades,
    ROUND(SUM(v.Cantidad * v.Precio), 2) as Ingresos
FROM Venta v
GROUP BY
    YEAR (v.Fecha)
ORDER BY Anio;

-- 4.5 Análisis temporal - Ventas por mes del año 2019
SELECT
    MONTH (v.Fecha) as Mes,
    COUNT(v.IdVenta) as Total_Ventas,
    ROUND(SUM(v.Cantidad * v.Precio), 2) as Ingresos
FROM Venta v
WHERE
    YEAR (v.Fecha) = 2019
GROUP BY
    MONTH (v.Fecha)
ORDER BY Mes;

-- 4.6 Clientes por rango de edad
SELECT
    CASE
        WHEN Edad < 20 THEN '< 20'
        WHEN Edad BETWEEN 20 AND 29  THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39  THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49  THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59  THEN '50-59'
        ELSE '60+'
    END as Rango_Edad,
    COUNT(*) as Cantidad_Clientes
FROM Clientes
WHERE
    Edad IS NOT NULL
GROUP BY
    CASE
        WHEN Edad < 20 THEN '< 20'
        WHEN Edad BETWEEN 20 AND 29  THEN '20-29'
        WHEN Edad BETWEEN 30 AND 39  THEN '30-39'
        WHEN Edad BETWEEN 40 AND 49  THEN '40-49'
        WHEN Edad BETWEEN 50 AND 59  THEN '50-59'
        ELSE '60+'
    END
ORDER BY Rango_Edad;

-- ================================================
-- NIVEL 5: ANÁLISIS DE NEGOCIO REAL
-- ================================================

-- 5.1 KPI: Ticket promedio por venta
SELECT ROUND(AVG(v.Cantidad * v.Precio), 2) as Ticket_Promedio
FROM Venta v;

-- 5.2 Análisis RFM simplificado (Recency, Frequency, Monetary)
SELECT
    c.Nombre_y_Apellido,
    c.Provincia,
    MAX(v.Fecha) as Ultima_Compra,
    COUNT(v.IdVenta) as Frecuencia,
    ROUND(SUM(v.Cantidad * v.Precio), 2) as Valor_Total
FROM Venta v
    INNER JOIN Clientes c ON v.IdCliente = c.ID
GROUP BY
    c.Nombre_y_Apellido,
    c.Provincia
HAVING
    COUNT(v.IdVenta) >= 5
ORDER BY Valor_Total DESC
LIMIT 20;

-- 5.3 Productos con mejor rotación
SELECT
    p.Concepto,
    p.Tipo,
    COUNT(DISTINCT v.IdCliente) as Clientes_Unicos,
    COUNT(v.IdVenta) as Num_Ventas,
    SUM(v.Cantidad) as Total_Unidades
FROM Venta v
    INNER JOIN Productos p ON v.IdProducto = p.ID_PRODUCTO
GROUP BY
    p.Concepto,
    p.Tipo
HAVING
    COUNT(v.IdVenta) >= 10
ORDER BY Num_Ventas DESC
LIMIT 15;

-- 5.4 Análisis de concentración - Provincias con más ventas
SELECT
    c.Provincia,
    COUNT(v.IdVenta) as Ventas,
    ROUND(SUM(v.Cantidad * v.Precio), 2) as Ingresos,
    COUNT(DISTINCT v.IdCliente) as Clientes_Activos,
    ROUND(
        SUM(v.Cantidad * v.Precio) / COUNT(DISTINCT v.IdCliente),
        2
    ) as Ingreso_Por_Cliente
FROM Venta v
    INNER JOIN Clientes c ON v.IdCliente = c.ID
WHERE
    c.Provincia IS NOT NULL
GROUP BY
    c.Provincia
ORDER BY Ingresos DESC
LIMIT 10;

-- 5.5 Productos que nunca se vendieron
SELECT p.Concepto, p.Tipo, p.Precio
FROM Productos p
    LEFT JOIN Venta v ON p.ID_PRODUCTO = v.IdProducto
WHERE
    v.IdVenta IS NULL;

-- ================================================
-- EJERCICIOS PARA PRACTICAR
-- Ver archivo: 03-ejercicios-alumnos.md
-- ================================================