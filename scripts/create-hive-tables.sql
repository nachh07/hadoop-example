-- ================================================
-- Script de Creación de Tablas Hive
-- Base de Datos Educativa - Ejemplo de Ventas
-- ================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS educacion_db COMMENT 'Base de datos educativa para ejemplos de Hive' LOCATION '/user/hive/warehouse/educacion_db.db';

USE educacion_db;

-- ================================================
-- Tabla: Clientes
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Clientes (
    ID INT,
    Provincia STRING,
    Nombre_y_Apellido STRING,
    Domicilio STRING,
    Telefono STRING,
    Edad INT,
    Localidad STRING,
    X DOUBLE,
    Y DOUBLE,
    Fecha_Alta STRING,
    Usuario_Alta STRING,
    Fecha_Ultima_Modificacion STRING,
    Usuario_Ultima_Modificacion STRING,
    Marca_Baja INT,
    col10 STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/data/input/' TBLPROPERTIES (
    'skip.header.line.count' = '1',
    'serialization.null.format' = ''
);

-- Crear tabla específica para Clientes (sin otras tablas)
DROP TABLE IF EXISTS Clientes;

CREATE EXTERNAL TABLE Clientes (
    ID INT,
    Provincia STRING,
    Nombre_y_Apellido STRING,
    Domicilio STRING,
    Telefono STRING,
    Edad INT,
    Localidad STRING,
    X DOUBLE,
    Y DOUBLE,
    Fecha_Alta STRING,
    Usuario_Alta STRING,
    Fecha_Ultima_Modificacion STRING,
    Usuario_Ultima_Modificacion STRING,
    Marca_Baja INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE LOCATION '/data/input/clientes/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Productos
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Productos (
    ID_PRODUCTO INT,
    Concepto STRING,
    Tipo STRING,
    Precio DECIMAL(10, 2)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/productos/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Ventas
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Venta (
    IdVenta INT,
    Fecha STRING,
    Fecha_Entrega STRING,
    IdCanal INT,
    IdCliente INT,
    IdSucursal INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio DECIMAL(10, 2),
    Cantidad INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/venta/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Empleados
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Empleados (
    ID_Empleado INT,
    Apellido STRING,
    Nombre STRING,
    Sucursal STRING,
    Sector STRING,
    Cargo STRING,
    Salario DECIMAL(10, 2)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/empleados/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Sucursales
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Sucursales (
    ID INT,
    Sucursal STRING,
    Direccion STRING,
    Localidad STRING,
    Provincia STRING,
    Latitud STRING,
    Longitud STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/sucursales/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Canal de Venta
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS CanalDeVenta (IdCanal INT, Canal STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/canal/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Compra
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Compra (
    IdCompra INT,
    Fecha STRING,
    IdProducto INT,
    Cantidad INT,
    Precio DECIMAL(10, 2),
    IdProveedor INT
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/compra/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Proveedores
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Proveedores (
    IDProveedor INT,
    Nombre STRING,
    Direccion STRING,
    Ciudad STRING,
    Provincia STRING,
    Pais STRING,
    Departamento STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/proveedores/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Gasto
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Gasto (
    IdGasto INT,
    IdSucursal INT,
    IdTipoGasto INT,
    Fecha STRING,
    Monto DECIMAL(10, 2)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/gasto/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Tipos de Gasto
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS TiposDeGasto (
    IdTipoGasto INT,
    Descripcion STRING,
    Monto_Aproximado DECIMAL(10, 2)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/tiposgasto/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Tabla: Calendario
-- ================================================
CREATE EXTERNAL TABLE IF NOT EXISTS Calendario (
    id INT,
    fecha STRING,
    anio INT,
    mes INT,
    dia INT,
    trimestre INT,
    semana INT,
    dia_nombre STRING,
    mes_nombre STRING
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/data/input/calendario/' TBLPROPERTIES (
    'skip.header.line.count' = '1'
);

-- ================================================
-- Verificar tablas creadas
-- ================================================
SHOW TABLES;