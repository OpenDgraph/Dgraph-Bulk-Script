#!/bin/sh

echo "================================================"
echo "  Welcome to the kitchen - Let's cook a bulk.   "
echo "================================================"
echo "================================================"


THIS_DIR=`dirname $0`
source $THIS_DIR/service/set-of-vars.sh

echo "$dgraphVersion"

render_template () {
  eval "echo \"$(cat $1)\""
}

start_to_cook () {

    questione_Host () {
    while true; do
    read -p "Do you wish to change host addr? (it's important) " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) return 1; break;;
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

    questione_Version () {
    while true; do
    read -p "Do you wish to change the Dgraph Version? " yn
    case $yn in
            [Yy]* ) return 0; break;;
            [Nn]* ) return 1; break;;
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
    questione_TheBind () {
    while true; do
    read -p "Do you wish to change the bindall default? " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) return 1; break;;
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

cook_Memory () {
    questione_Memory () {
    while true; do
    read -p "Do you wanna increase the memory? " yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) return 1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
if questione_Memory; then
    echo "Please enter your (default: $my_server_memory ): "
    read input_variableM
    my_server_memory=${input_variableM}
    echo "You defined: $input_variableM as your addr"
        else
        return 0
     fi
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
  render_template ./templates/docker-compose.yaml > ./docker-compose.yml
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
  newMy_server_memory=${my_server_memory}
  render_template ./templates/set-of-vars.tmpl > ./service/set-of-vars.sh
    echo "#### done!"
}


 if questione_it; then
    start_to_cook
    cook_version
    cook_Bind
    cook_Memory
    generate_docker_compose
    generate_bulk_script
 echo "
  new Dgraph Version ${dgraphVersion}
  new Addr Host ${addrHost}
  new Bindall ${bindall}
  New Zero Port ${zeroPort}
  New Memory value ${my_server_memory}"
 echo "#### Everything done! go compose it up!"
    else
        exit
  fi
exit