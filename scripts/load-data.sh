#!/bin/bash

echo "================================================"
echo "Cargando datos CSV a HDFS"
echo "================================================"

# Esperar a que HDFS esté disponible
until hdfs dfsadmin -report 2>/dev/null | grep -q "Live datanodes"; do
  echo "Esperando HDFS..."
  sleep 5
done

echo "✓ HDFS está disponible"

# Verificar que el directorio /data/input existe
echo "Verificando directorio de destino..."
hdfs dfs -test -d /data/input
if [ $? -ne 0 ]; then
    echo "Creando directorio /data/input..."
    hdfs dfs -mkdir -p /data/input
    hdfs dfs -chmod 755 /data/input
fi

echo "✓ Directorio /data/input listo"

# Cargar todos los archivos CSV
echo ""
echo "Cargando archivos CSV desde /data a HDFS..."
echo ""

CSV_COUNT=0
for file in /data/*.csv; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "  Cargando: $filename"
        hdfs dfs -put -f "$file" /data/input/
        if [ $? -eq 0 ]; then
            CSV_COUNT=$((CSV_COUNT + 1))
            echo "    ✓ $filename cargado exitosamente"
        else
            echo "    ✗ Error al cargar $filename"
        fi
    fi
done

echo ""
echo "================================================"
echo "Resumen de carga:"
echo "  - Archivos cargados: $CSV_COUNT"
echo ""

# Listar archivos en HDFS
echo "Archivos en HDFS /data/input:"
hdfs dfs -ls /data/input

echo ""
echo "Espacio utilizado:"
hdfs dfs -du -h /data/input

echo ""
echo "================================================"
echo "✓ Carga de datos completada"
echo "================================================"
