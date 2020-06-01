#!/bin/bash

service_loc="service-k8s"
DIR="./out/0"

THIS_DIR=`dirname $0`
source $THIS_DIR/set-of-vars.sh

echo "$THIS_DIR THIS_DIR"
echo "$dgraphVersion dgraphVersion"

SCHEMA="./${service_loc}/release.schema"
RDFFILE="./${service_loc}/1million.rdf.gz"


my_alpha=${addrHost}:7080
my_zero=${addrHost}:${zeroPort}


my_alpha_p_0=${DIR}/p


echo "========================================="
echo "Log of Vars"
echo "========================================="

ls -la .

echo "Current ==> Location $(pwd)"

echo "DIR DIR"
echo "SCHEMA ${SCHEMA}"
echo "RDFFILE ${RDFFILE}"
echo "my_alpha ${my_alpha}"
echo "my_zero ${my_zero}"
echo "my_alpha_memory ${my_alpha_memory}"
echo "my_alpha_p_0 ${my_alpha_p_0}"
echo "========================================="

 check_existing_dir () {
      if [ ! -d "${DIR}" ]; then
          echo "directory OUT/ from Bulk - not found!"
          return 1
      else
          echo "$DIR WOOOOHOOOOO we have a directory!"
          echo "================= DIR ==================="
          ls -la $DIR
          echo "========================================="
          return 0
      fi
}


 check_existing_Schema () {
      if [ ! -f "${SCHEMA}" ]; then
          echo "Schema not found!"
          return 1
      else
          # echo "$FILE WOOOOHOOOOO"
          echo "=================Schema=================="
          cat $SCHEMA
          echo "========================================="
          return 0
      fi
}

 check_existing_RDF () {
      if [ ! -f "${RDFFILE}" ]; then
          echo "RDF not found!"
          return 1
      else
          # echo "$FILE WOOOOHOOOOO"
          echo "=================We have a RDF file =================="
          return 0
      fi
}

   tell_him () {
      echo "No need for a Bulk today!"
  }

   RUN_alpha () {
      echo "Dgraph Alpha Starting ..."
      dgraph alpha --bindall=true --my=${my_alpha} --lru_mb=${my_alpha_memory} --zero=${my_zero} -p ${my_alpha_p_0}
  }

   RUN_BulkLoader () {
    if check_existing_RDF; then
      echo "Dgraph BulkLoader Starting..."
      dgraph bulk -f ${RDFFILE} -s ${SCHEMA} --reduce_shards=1 --zero=${my_zero}
      return 0
      else
       echo "You neet to provide a RDF and a Schema file"
      return 1
    fi
  }

  if check_existing_dir; then
    tell_him
    RUN_alpha
    else
    if RUN_BulkLoader; then
    RUN_alpha
    fi
  fi

exit