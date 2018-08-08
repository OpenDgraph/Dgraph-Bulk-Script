#!/bin/sh

echo "================================================"
echo "     Welcome to Dgraph Launch Pad for k8s.      "
echo "================================================"
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

 add_lock () {
     #Todo prepare locks to be delivered
    echo 'touch done0.lock & touch done1.lock 
    & touch done2.lock & touch done3.lock 
    & touch done4.lock & touch done5.lock 
    & touch done6.lock & touch done7.lock'
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
     echo 'Downloading dgraph-ha.yaml'
     cd ./tmp  
     curl -LJO https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-ha.yaml
     cd ..
     echo 'Deploying dgraph-ha.yaml'
     kubectl create -f ./tmp/dgraph-ha.yaml
}

create_deployment_mt () {
     echo 'Downloading dgraph-multi.yaml'
     cd ./tmp  
     curl -LJO https://raw.githubusercontent.com/dgraph-io/dgraph/master/contrib/config/kubernetes/dgraph-multi.yaml
     cd ..
     echo 'Deploying dgraph-multi.yaml'
     kubectl create -f ./tmp/dgraph-multi.yaml
}

exec_on_pod () {
    echo '# kubectl exec -it dgraph-server-0 -- /bin/bash'
}

exec_export_on_pod () {
    echo 'Working on your export file...'
    kubectl exec dgraph-server-0 curl localhost:8080/admin/export
    echo 'Export done!'
}

get_log_from_pod () {
     echo 'kubectl logs $POD_NAME'
}

Send_RDF_to_pod (){
    kubectl cp /tmp/foo_dir dgraph-server-0:/dgraph/
}

Copy_an_Export () {
    if  exec_export_on_pod; then
    echo 'Copyng RDF from dgraph-server-0 to tmp folder...'
     mkdir tmp
     kubectl cp dgraph-server-0:/dgraph/export/ ./tmp/export/
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
     kubectl cp dgraph-server-0:/dgraph/export/* ./service-k8s/*
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
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option4")
            echo "you chose choice $REPLY"
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
        "${Option1}")
            create_deployment
            break
            ;;
        "$Option2")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option3")
            echo "you chose choice $REPLY"
            break
            ;;
        "$Option4")
            echo "you chose choice $REPLY"
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
    read -p "Are these nodes connected to your system that you want to use? Do you want to continue?" yn
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