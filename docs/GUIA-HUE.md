# Guía Rápida: Usando Hue para Consultas Hive

## ¿Qué es Hue?

Hue (Hadoop User Experience) es una interfaz web que facilita el trabajo con Hadoop. Proporciona:
- Editor SQL visual para HiveQL
- Navegador de archivos HDFS
- Historial de consultas
- Visualización de resultados

## Acceso

1. Abre tu navegador en: **http://localhost:8888**
2. Primera vez: crea un usuario `admin` con tu contraseña
3. ¡Listo para usar!

## Primeros Pasos

### 1. Ejecutar Tu Primera Consulta

1. En el menú superior, haz clic en **"Query" > "Editor" > "Hive"**
2. En el panel izquierdo verás la base de datos `educacion_db` y sus tablas
3. Escribe una consulta en el editor:
   ```sql
   USE educacion_db;
   SELECT * FROM productos LIMIT 10;
   ```
4. Presiona el botón **"Execute"** (▶️) o `Ctrl+Enter`
5. Los resultados aparecerán abajo en formato tabla

### 2. Explorar las Tablas

- Panel izquierdo: lista de databases
- Haz clic en `educacion_db` para expandir
- Haz clic en cualquier tabla (ej: `productos`) para ver:
  - Columnas y tipos de datos
  - Vista previa de datos
  - Estadísticas

### 3. Navegar HDFS

1. Menú superior: **"Browsers" > "Files"**
2. Navega a `/data/input`
3. Verás todos tus archivos CSV
4. Puedes:
   - Ver archivos
   - Descargar
   - Subir nuevos archivos
   - Crear directorios

### 4. Guardar Consultas

1. Escribe tu consulta
2. Haz clic en el ícono 💾 "Save"
3. Dale un nombre descriptivo (ej: "Top 10 Productos")
4. Accede después desde **"Saved Queries"**

## Consultas de Ejemplo para Probar

### Básicas
```sql
-- Contar productos por tipo
SELECT Tipo, COUNT(*) as Total
FROM productos
GROUP BY Tipo
ORDER BY Total DESC;
```

### Con JOIN
```sql
-- Ventas con información de producto
SELECT 
    v.IdVenta,
    p.Concepto as Producto,
    p.Tipo,
    v.Cantidad,
    v.Precio,
    (v.Cantidad * v.Precio) as Total
FROM venta v
INNER JOIN productos p ON v.IdProducto = p.ID_PRODUCTO
LIMIT 20;
```

### Análisis
```sql
-- Top 10 clientes por gasto total
SELECT 
    c.Nombre_y_Apellido,
    c.Provincia,
    COUNT(v.IdVenta) as Total_Compras,
    SUM(v.Cantidad * v.Precio) as Gasto_Total
FROM venta v
INNER JOIN clientes c ON v.IdCliente = c.ID
GROUP BY c.Nombre_y_Apellido, c.Provincia
ORDER BY Gasto_Total DESC
LIMIT 10;
```

## Características Útiles

### Autocompletado
- Escribe `SELECT * FROM ` y presiona `Ctrl+Espacio`
- Hue te sugerirá tablas y columnas

### Formateo de Código
- Selecciona tu query
- Haz clic derecho > "Format SQL"

### Exportar Resultados
- Después de ejecutar una consulta
- Haz clic en ⬇️ "Download"
- Opciones: CSV, Excel, JSON

### Historial
- Menú: **"Query History"**
- Ver todas las consultas ejecutadas
- Re-ejecutar consultas pasadas

## Tips para la Clase

1. **Para Demostración en Vivo**: Usa Hue, es mucho más visual que beeline
2. **Para que los Alumnos Practiquen**: Mejor si tienen acceso a Hue
3. **Para Desarrollo Rápido**: El autocompletado acelera mucho

## Solución de Problemas

### "Database is locked"
- Espera 10-15 segundos y recarga la página
- Es normal la primera vez que accedes

### No veo las tablas
1. Verifica que estás en `educacion_db`
2. Refresca el panel izquierdo (ícono 🔄)

### Query tarda mucho
- Es normal en la primera ejecución
- Siguientes queries serán más rápidas

---

**¡Disfruta de la interfaz gráfica!** 🎨

Para más detalles, consulta: [Documentación de Hue](https://docs.gethue.com/)
