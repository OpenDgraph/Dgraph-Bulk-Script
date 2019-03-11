#!/bin/sh

#TODO FIX THE YAML PORTS, they are "strings" for K8s, they don't like tho.

DATE=$(date +'%Y-%m-%d')

echo "================================================"
echo "     Welcome to Dgraph Launch Pad for k8s.      "
echo "================================================"
echo "================= $DATE ==================="
echo "================================================"
echo ''

check_cluster () {
    echo 'Checking if you have an cluster running...'
echo "================== Config ======================"
    kubectl config current-context
echo "================================================"
echo ''
echo ''
}

 check_cluster_info () {
    echo 'Checking if you have an cluster running...'
    kubectl cluster-info
}
 check_nodes () {
        checknodes () {
            kubectl get nodes
        }
    if  checknodes; then
        echo 'checknodes true'
        echo ''
    else
    echo 'Are sure you have any deployments on your cluster? no Nodes found, exiting...'
    exit
    fi
}

create_deployment () {
    #  echo 'Downloading dgraph-ha.yaml'
    #  cd ./tmp
    # #  curl -LJO https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-ha.yaml
    #  cd ..
     echo 'Deploying dgraph-ha.yaml'
     kubectl create -f https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-ha.yaml
    #  kubectl create -f ./tmp/dgraph-ha.yaml
}

create_deployment_mt () {
    #  echo 'Downloading dgraph-multi.yaml'
    #  cd ./tmp  
    #  curl -LJO https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-multi.yaml
    #  cd ..
     echo 'Deploying dgraph-multi.yaml'
     kubectl create -f https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-multi.yaml
    #  kubectl create -f ./tmp/dgraph-multi.yaml
}

 add_lock () {
     #Todo prepare locks to be delivered
    echo 'touch done0.lock & touch done1.lock 
    & touch done2.lock & touch done3.lock 
    & touch done4.lock & touch done5.lock 
    & touch done6.lock & touch done7.lock'
}

 Att(){
    echo "################################"
    echo 'if you see "dgraph-alpha-public" already exists - DON NOT continue'
    echo 'you need a clean cluster immediately'
    echo "################################"
    sleep 4;
 }


check_dpl() {
    runIT(){
        echo "Please Wait..."
        sleep 10;
        kubectl get -f dgraph-ha.yaml
    }
    runIT
    while true; do
    read -p "So, are all dgraph-alpha and dgraph-zero pods ready? Make sure (see DESIRED for CURRENT)" yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) runIT; continue;;
        * ) echo "Please answer yes or no.";;
    esac
done    
    # kubectl wait --for=condition=available --timeout=60s 
#   for node in $nodes; do
#   echo "Node: $node"
#   kubectl describe node "$node" | sed '1,/Non-terminated Pods/d'
#   echo
# done
return 1
}

k8s_dpl() {
  kubectl create -f ./service-k8s/dgraph-ha-with-bulk.yaml
  Att
}

 warningalpha() {
    echo "################################"
    echo "Attention: You need to set a clean Cluster to continue this process"
    echo "Please, delete your kubernetes previous deployments"
    echo "################################"
}

questione_about_alpha () {
    while true; do
    read -p "Are you sure that want continue? Observe that you need a clean cluster from this point" yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) warningalpha; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

Send_RDF_to_pods (){
    kubectl cp ./service-k8s/ dgraph-alpha-0:/dgraph/
}

create_deployment_with_bulk () {
    echo "Checking RDF files on service-k8s..."
    sleep 1;
        if [ -f ./service-k8s/*.gz ]; then
        if questione_about_alpha; then
        k8s_dpl
        echo "Wait for k8s to be ready..."
        sleep 2;
            if check_dpl; then
            echo "Sending service-k8s folder to all pods" & sleep 6; echo "wait"
            Send_RDF_to_pods
            echo "Sucesso"
            fi
        fi
        return 0
        else
        echo "No gz file found, seems you don't have any RDF ready"
        sleep 1;
        warningRDF
        return 1
    fi
        
}

exec_on_pod () {
    echo '# kubectl exec -it dgraph-alpha-0 -- /bin/bash'
}

exec_export_on_pod () {
    echo 'Working on your export file...'
    kubectl exec dgraph-alpha-0 curl localhost:8080/admin/export
    echo 'Export done!'
}

get_log_from_pod () {
     echo 'kubectl logs $POD_NAME'
}

Copy_an_Export () {
    if  exec_export_on_pod; then
    echo 'Copyng RDF from dgraph-alpha-0 to tmp folder...'
     mkdir tmp
     kubectl cp dgraph-alpha-0:/dgraph/export/ ./tmp/export/
    else
    echo ' Export Fail!'
    exit
     fi
    #     if  copythen; then
    #     echo ' Copy done!'
    #     else
    #     echo 'Are sure you are conected to you cluster? no Pods found, check your internet - exiting...'
    #     exit
    #   fi
}

Copy_an_Export_to_bulk () {
     #TODO need to add here INPUT options to change the file name
     copythen (){
     echo 'Copyng from pod to service-k8s folder...'
     kubectl cp dgraph-alpha-0:/dgraph/export/ ./service-k8s/
        }
  if  copythen; then
   echo ' Copy done!'
   else
    echo 'Are sure you are conected to you cluster? no Pods found, check your internet'
    sleep 2;
    echo 'Seems that you dont have any RDF exported - exiting...'
    exit
fi
}

 warningRDF() {
    echo "################################"
    echo "Attention: You need to set a RDF file to continue this process"
    echo "Please, choose Option 1 or export some RDF, or try Option 6"
    echo "################################"
}

questione_about_RDF () {
    while true; do
    read -p "Do you have a RDF file ready in service folder? (or service-k8s in case)" yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) warningRDF; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}


    Prepare_Launch () {
    echo "================================================"
    echo "        Prepare for Launch T- 00:03:00.         "
    echo "================================================"

Option1="- Run a clean setup of dgraph-ha.yaml"
Option2="- Run a clean setup of dgraph-multi.yaml"
Option3="- Run dgraph-ha.yaml with a process to BULK (Need a RDF file in service-k8s)"
Option4="- Run dgraph-multi.yaml with a process to BULK (Need a RDF file in service-k8s)"
Option5="- Just generate and copy an Export from Dgraph"
Option6="- Copy an Export generated in Dgraph and send to /service-k8s to prepare to bulk"
Option7="- See OTHER options (Wanna bulk with our examples?)"

PS3='Please enter your choice: '
options=("${Option1}" "$Option2" "$Option3" "$Option4" "$Option5" "$Option6" "$Option7" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${Option1}")
            create_deployment
            break
            ;;
        "$Option2")
            create_deployment_mt
            break
            ;;
        "$Option3")
         if questione_about_RDF; then
            
            create_deployment_with_bulk
         fi
            break
            ;;
        "$Option4")
         if questione_about_RDF; then
            echo test
         fi
            break
            ;;
        "$Option5")
            Copy_an_Export
            break
            ;;
        "$Option6")
            Copy_an_Export_to_bulk
            break
            ;;
        "$Option7")
            Prepare_Launch_other
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
}


    Prepare_Launch_other () {
    echo "================================================"
    echo "        Prepare for Launch T- 00:04:00.   Pad B "
    echo "================================================"

Option8="- Run a LiveLoad locally with your Cluster"
Option9="- Run a LiveLoad on Cluster with local RDF"
Option10="- Run a LiveLoad on Cluster with RDF example from Dgraph"
Option11="- Run dgraph-multi.yaml with a process to BULK (Need a RDF file in service-k8s)"
Option12="- Just generate and copy an Export from Dgraph"
Option13="- Copy an Export generated in Dgraph and send to /service-k8s to prepare to bulk"
Option14="- OTHER options (Wanna bulk with our examples?)"

PS3='Please enter your choice: '
options=("${Option8}" "$Option9" "$Option10" "$Option11" "$Option12" "$Option13" "$Option14" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${Option8}")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option9")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option10")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option11")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option12")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option13")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option14")
            echo "you chose choice $REPLY"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
}

questione_it_k8s () {
    while true; do
    read -p "This is the current k8s context. Do you want to continue?" yn
    case $yn in
        [Yy]* ) return 0; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

some_more () {
    while true; do
    read -p "Do you wanna do something else? " yn
    case $yn in
        [Yy]* ) Prepare_Launch; continue;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

}

main (){
 if check_cluster; then
   questione_it_k8s
   Prepare_Launch
   some_more
 fi
}

main