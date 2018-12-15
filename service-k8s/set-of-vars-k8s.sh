#!/bin/sh

dgraphVersion=v1.0.11-rc4
addrHost=
Rep0=3
zeroPortDF=5080
ServerReplicasDF=6
DfcurlAdd='https://raw.githubusercontent.com/MichelDiz/test/master/test.sh'

#Zero Configs
bindall=true
zeroPort=5080
zeroReplicas=3
idxk8s='$idx'
serviceName='dgraph-zero'
#Server Configs
ServerReplicas=6
my_server_memory=2048
StorageType=ssd

curlCommand='curl -LJO https://raw.githubusercontent.com/MichelDiz/test/master/test.sh && echo downloaded && sh ./test.sh &&'

#safe command templating
clipCommandServerLine2='"-c"'
pipeCmd='|'
clipCommandServerLine5='[[ `hostname` =~ -([0-9]+)$ ]] || exit 1 
              ordinal=${BASH_REMATCH[1]} 
              idx=$(($ordinal + 1)) 
              if [[ $ordinal -eq 0 ]]; then '
