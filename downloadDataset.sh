#! /usr/bin/env bash


URL_1M="https://github.com/dgraph-io/benchmarks/blob/master/data/1million.rdf.gz?raw=true"
URL_schema="https://github.com/dgraph-io/benchmarks/blob/master/data/release/release.schema?raw=true"

curlData(){
    curl --progress-bar -LS -o $1 "$2"
}

if [ ! -f ./datasets/release.schema ]; then
    echo "release.schema File does not exist"
    curlData "./$@/release.schema" $URL_schema
else 
    echo "release.schema exists"
fi

if [ ! -f ./datasets/1million.rdf.gz ]; then
    echo "1million File does not exist"
    curlData "./$@/1million.rdf.gz" $URL_1M
else 
    echo "1million.rdf.gz exists"
fi
