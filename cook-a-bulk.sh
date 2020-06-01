#!/bin/sh

set -e

DATE=$(date +'%Y-%m-%d')

echo "================================================"
echo "  Welcome to the kitchen - Let's cook a bulk.   "
echo "================================================"
echo "================= $DATE ==================="
echo "================================================"


set_vars_docker (){
THIS_DIR=`dirname $0`
source $THIS_DIR/service/set-of-vars.sh
echo "Using vars for docker"
echo "The version we are using is ==> $dgraphVersion"
}

set_vars_k8s (){
THIS_DIR=`dirname $0`
echo "Using vars for kubernetes"
source $THIS_DIR/service-k8s/set-of-vars-k8s.sh

echo "The version we are using is ==> $dgraphVersion"
}


render_template () {
  eval "echo \"$(cat $1)\""
}

start_to_cook () {

     checkDFHost () {
     if [ !$addrHost ];
     then
     echo 'Theres no default addr'
     addrHost=192.168.99.100
     echo "Defining ${addrHost} as default addr"
     else
     echo "ure using ${addrHost} addr"
     fi 
     } 

    questione_Host () {
    while true; do
    read -p "Do you wish to change host addr? (it's important) " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) checkDFHost; return 1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
if questione_Host; then
    echo "Please enter your Docker Host IP (default: $addrHost - Don't add ports just addr or IP): "
    read input_variableH
    addrHost=${input_variableH}
    echo "You defined "$input_variableH" as your addr"
    else
      return 0
     fi

}

cook_version () {
 checkDF () {
     if [ !$dgraphVersion ];
     then
     echo 'Theres no default version'
     dgraphVersion='v20.03.2'
     echo "Defining ${dgraphVersion} as default version"
     else
     echo "ure using ${dgraphVersion} version"
     fi 
     } 

    questione_Version () {
    while true; do
    read -p "Do you wish to change the Dgraph Version? " yn
    case $yn in
            [Yy]* ) return 0; break;;
            [Nn]* ) checkDF; return 1; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    }

if questione_Version; then
    echo "Please enter the desired Dgraph Version - Only docker TAG (default: $dgraphVersion ): "
    read input_variableV
    dgraphVersion=${input_variableV}
    echo "You defined: $input_variableV as the Dgraph Version"
    else
      return 0
     fi
}


cook_Bind () {
     checkDFBind () {
     if [ !$bindall ];
     then
     echo 'Theres no default bindall'
     bindall=true
     echo "Defining ${bindall} as default bind"
     else
     echo "ure using ${bindall} as default bind"
     fi 
     } 
    questione_TheBind () {
    while true; do
    read -p "Do you wish to change the bindall default? " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) checkDFBind; return 1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
if questione_TheBind; then
    echo "Select your value (default: is $bindall )"
        select yn in "True" "False"; do
            case $yn in
                True ) bindall=true; break;;
                False ) bindall=False 
                echo "You defined: bindall as $bindall"; break;;
            esac
            
        done
            else
                return 0
     fi
}

cook_Storage () {
     checkDFST () {
     if [ !$StorageType ];
     then
     echo 'Theres no default Storage Type'
     StorageType='ssd'
     echo "Defining ${StorageType} as default Storage Type"
     else
     echo "ure using ${StorageType} as Storage Type"
     fi 
     } 
    questione_The_StorageType () {
    while true; do
    read -p "Do you wish to change the Storage type? " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) checkDFST; return 1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
if questione_The_StorageType; then
        Option1="- I'm using SSD"
        Option2="- I'm using HDD (harddrive)"

        PS3='Please enter your choice: '
        options=("${Option1}" "$Option2")
        select opt in "${options[@]}"
        do
            case $opt in
                "${Option1}")
                    echo "You defined: $StorageType as default"
                    return 0
                    break
                    ;;
                "$Option2")
                    echo "You defined: $StorageType as default"
                    return 1
                    break
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done
             else
                return 0
     fi

}

cook_Memory () {
     checkDFMemo () {
     if [ !$my_alpha_memory ];
     then
     echo 'Theres no default version'
     my_alpha_memory=2048
     echo "Defining ${my_alpha_memory} as default memory"
     else
     echo "ure using ${my_alpha_memory} of memory"
     fi 
     } 
    questione_Memory () {
    while true; do
    read -p "Do you wanna increase the memory? " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) checkDFMemo; return 1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
if questione_Memory; then
    echo "Please enter your (default: $my_alpha_memory ): "
    read input_variableM
    my_alpha_memory=${input_variableM}
    echo "You defined: $input_variableM as your addr"
        else
        return 0
     fi
}

questione_it_type () {


Option1="- Cook a Docker-compose"
Option2="- Cook a kubernetes yaml"

PS3='Please enter your choice: '
options=("${Option1}" "$Option2" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${Option1}")
            echo "So, let's cook a Docker-compose"
            return 0
            break
            ;;
        "$Option2")
            echo "So, let's cook a kubernetes yaml"
            return 1
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

}

questione_it () {
    while true; do
    read -p "Do you wish to create a new process? will override the old files " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
}


 generate_docker_compose () {
  echo "#### Creating docker-compose ..."
  render_template ./templates/docker-compose.yaml > ./service/docker-compose.yml
}

 generate_bulk_script () {
  echo "#### Creating a NEW set-of-vars.sh ..."
  newDgraphVersion=${dgraphVersion}
  a='./${p'
  b='wd}'
  newLocalPath=\'${a}${b}\'
  newAddrHost=${addrHost}
  newBindall=${bindall}
  NewZeroPort=${zeroPort}
  newMy_alpha_memory=${my_alpha_memory}
  render_template ./templates/set-of-vars.tmpl > ./service/set-of-vars.sh
    echo "#### done!"
}

 generate_k8s_yaml_bulk () {
  echo "#### Creating dgraph-ha-with-bulk.yaml ..."
  render_template ./templates/dgraph-ha-with-bulk.yaml > ./service-k8s/dgraph-ha-with-bulkTESTE.yaml
}

gen_scrt(){
    cat << _EOF_ 
'[[ \`hostname\` =~ -([0-9]+)$ ]] || exit 1 
              ordinal=\${BASH_REMATCH[1]} 
              idx=\$((\$ordinal + 1)) 
              if [[ \$ordinal -eq 0 ]]; then '

_EOF_
}

# back-up
# '\"[[ \`hostname\` =~ -([0-9]+)$ ]] || exit 1 \\${newLine}n
# ordinal=\${BASH_REMATCH[1]} \\${newLine}n
# idx=\$(($ordinal + 1)) \\${newLine}n
# if [[ $ordinal -eq 0 ]]; then \\${newLine}n \"'

 generate_k8s_bulk_script () {
  echo "#### Creating a NEW set-of-vars-k8s.sh ..."
  newDgraphVersion=${dgraphVersion}
  a='$'
  b='idx'
  newIdxk8s=\'${a}${b}\'
  newAddrHost=${addrHost}
  newBindall=${bindall}
  NewZeroPort=${zeroPort}
  SType=${StorageType}
  newMy_alpha_memory=${my_alpha_memory}
  NewclipCommandalphaLine5=$(gen_scrt)
  Thisa=''
  Thisb='"-c"'
  AWAITCMD=\'${Thisa}${Thisb}\'
  curling='curl -LJO '${DfcurlAdd}' && echo downloaded && sh ./test.sh &&'
  curling2=
  NewcurlCommand=\'${curling}\'
#    gen_scrt > NewclipCommandalphaLine5
  render_template ./templates/set-of-vars-k8s.tmpl > ./service-k8s/set-of-vars-k8s.sh
    echo "#### done!"
}

warning() {
    echo "################################"
    echo "Attention: If for some reason the files don't update"
    echo "Please, redo this process"
    echo "################################"
}


 if questione_it_type; then
        set_vars_docker
        questione_it
        start_to_cook
        cook_version
        cook_Bind
        cook_Memory
        echo "
        new Dgraph Version ${dgraphVersion}
        new Addr Host ${addrHost}
        new Bindall ${bindall}
        New Zero Port ${zeroPort}
        New Memory value ${my_alpha_memory}"
        generate_docker_compose
        generate_bulk_script
        echo "#### Everything done! go compose it up!"
     else
        if questione_it; then
                set_vars_k8s
                cook_version
                cook_Storage
                cook_Bind
                cook_Memory
                echo "
                new Dgraph Version ${dgraphVersion}
                new Storage Type ${StorageType}
                new Bindall ${bindall}
                New Zero Port ${zeroPort}
                New Memory value ${my_alpha_memory}"
                generate_k8s_yaml_bulk
                generate_k8s_bulk_script
                echo "#### Everything done! go run k8s-up.sh!"
    fi
    warning
    exit
  fi
  warning
exit