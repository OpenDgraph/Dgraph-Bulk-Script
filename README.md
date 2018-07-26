# Dgraph bulkload

## A Docker-compose with .sh

Well, the script is simple and will do everything for you if you copy this repo completely. It will check if the Bulk has already been performed and then decide whether to run the server or not. Shortly after the Bulk it runs the server automatically.

There is not much secret in this script. If you need to copy feel free to create a flow for your project.

Attention! Before using modify the vars using 

````
> # sh ./cook-a-bulk.sh
````

With /cook-a-bulk.sh you'll be able to modify the docker-compose and the vars in one shot! xD
Just run and accept or decline the questions.

````
my_server=192.168.99.100:7080 #if you use "localhost:7080"
my_zero=192.168.99.100:5080 #if you use "localhost:5080"
my_server_memory=2048
dgraphVersion=v1.0.7
````

OBS: This PJ was made on MacOS (Darwin), to work on other systems few things need to be modified. For example, Docker-compose may work differently on Windows as the volume paths.

## commands "copy paste":

Under this repo you have to use docker compose

```docker-compose up -d```

or

```docker-compose up ```
To see Logs

After the Bulk go to Ratel:

```192.168.99.100:8000```

or

```localhost:8000```

# Query for

Right after the bulkload and then the server is UP. Query in Ratel for this:

````
{
  caro(func: allofterms(name@en, "Marc Caro")) {
    name@en
    director.film {
      name@en
    }
  }
  jeunet(func: allofterms(name@en, "Jean-Pierre Jeunet")) {
    name@en
    director.film {
      name@en
    }
  }
}
````

Should appears 10 nodes and 10 edges.


# Others tips

if you need to download the RDF and use in some kind of test out (with this repo, don't need tho)

```` wget "https://github.com/dgraph-io/tutorial/blob/master/resources/1million.rdf.gz?raw=true" -O 1million.rdf.gz -q ````

if you need to use vim create those files before (don't need tho)

````touch docker-compose.yml && touch 1million.schema ````


in ".schema" just paste your schema or the 1million example. (don't need tho)


### Cleanup Docker

````
docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

docker volume ls

docker volume rm dgraphbulkscript_dgraph
# or
docker volume rm ${name_of_yourCOmpose}
````

## Anything about Dgraph go to 
https://docs.dgraph.io/

## Te get in touch to our community go to 
https://discuss.dgraph.io/


> # PS. the docker-compose is set to use Dgraph V1.0.7