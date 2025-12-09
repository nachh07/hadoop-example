#!/bin/bash

echo "================================================"
echo "Inicializando HDFS para el entorno educativo"
echo "================================================"

# Esperar a que HDFS esté disponible
echo "Esperando a que HDFS esté disponible..."
until hdfs dfsadmin -report 2>/dev/null | grep -q "Live datanodes"; do
  echo "Esperando HDFS..."
  sleep 5
done

echo "✓ HDFS está disponible"

# Crear estructura de directorios estándar
echo "Creando estructura de directorios en HDFS..."

hdfs dfs -mkdir -p /user
hdfs dfs -mkdir -p /user/hive
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /data
hdfs dfs -mkdir -p /data/input

# Configurar permisos
echo "Configurando permisos..."
hdfs dfs -chmod -R 777 /tmp
hdfs dfs -chmod -R 777 /user/hive/warehouse
hdfs dfs -chmod -R 755 /data

echo "✓ Directorios creados exitosamente"

# Listar estructura creada
echo ""
echo "Estructura HDFS creada:"
hdfs dfs -ls -R /

echo ""
echo "================================================"
echo "✓ Inicialización de HDFS completada"
echo "================================================"
