# Running Taskmanager on kubernetes environment

## Requirements

* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* [Minikube/Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/install-minikube/).
 * [Helm package manager](https://helm.sh/).
 * [Docker](https://docs.docker.com/install/).

## Steps to run taskmanager on Minikube

 1. Download and install minikube on your system using the link provided in requirement section.
2. start minikube on your system using following command.
             `sh minikube start `
Minikube will be configired on your system, check minikube version ```minikube version```
3. Initiate Helm with tiller. (`helm init --upgrade`)   
4. This k8s folder contains 4 subfolders, each folder contains the config of chart of respective appliucation.
    *   ***a. Create postgres pods***
        Postgres is the database we use in this application to read and write the data. Our application is depending on postgres and we need to bring it up before starting other applications. Database configuration and properties are set under postgres/values.yaml.
        Bring up postgres pod by running `helm install postgres --name postgres `. This will bring up the postgress application with *persistent volume*. of 10gb. Environment variables are configures under config map. 
    *    ***b. Create Web app***
                You need to generate docker images of this application and push to repository before moving to next step. Generate docker images by running ```bash -x build.sh``` under root folder of this application. That will generate two images for webapp and one for sceduler.
                Create a new tag for pushing to your fav registry, here we are pushing to dockerhub. If you would like to push to your own registry,then you will have to bring up your own registry by running `bash local_reg.sh` in your system.
                Create a new tag for webapp image and push to repository.
                `docker tag webapp:latest <your_namespace>/webapp`
                ```docker push <your_namespace>/webapp``` 
                Above command will push the images to docker registry, you need to login to docker registry for the sucessful push.
                Now install webapp package and create webapp deployments under your cluster. `helm install webapp --name webapp`.
             You can update image by running ```helm upgrade --install webapp ./webapp --set image.repository=<yournampespace>/webapp```
    *    ***c. Create Scheduler app*** 
                  `helm install scheduler --name scheduler` You can update image by running
            `helm scheduler --name scheduler ./scheduler --set image.repository=<yournampespace>/scheduler` . Now all the services are up and running, make sure all pods are running ```kubectl get pods```. You can also see the pods status in UI, just run ```minikube dashboard```. It will take you to dashboard where you can see configuration information.

## Access UI
Task manager UI can be accessible in two ways.  One is nodePort method and another is ingress (with DNS).
                    1. Node port   
                        ```export NODE_PORT=$(kubectl get --namespace default jsonpath="{.spec.ports[0].nodePort}" services webapp)
                    export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
                            echo http://$NODE_IP:$NODE_PORT```
                    2. Ingress endpoint
                        * ```kubectl apply -f ingress/ingress.yaml```  
                        * ```kubectl apply -f ingress/ingress.yaml```
                    Ingress rules have been created with the above command. Now access taks manager web page with ```minikube up```      

 # Special instruction to run kubernetes with private registry.
1. Create Private registry. 
a. Run ```./local_registry.sh &``` on your system, your registry will start on port 5000.
            b. You can point your dns to the server and get the private registry namespace.
2. Tag your image with your private registry
            ```docker tag <image_name>:<tag> <private_registry_image>:tag```
3. Push image to your private registry
                ``` docker push     <private_registry_image>:tag```
4. Create secret in your k8s cluster. 
                  ```kubectl create secret docker-registry regcred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email> ```
5. Update your image information and secret information in deployment file.
                  

