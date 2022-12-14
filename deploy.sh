#add the ingress ngix pod
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-release ingress-nginx/ingress-nginx

#notice the two tags:
docker build -t crkepler/multi-client-k8s:latest -t crkepler/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t crkepler/multi-server-k8s-pgfix:latest -t crkepler/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t crkepler/multi-worker-k8s:latest -t crkepler/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

#need to push same image twice, each with different tag
docker push crkepler/multi-client-k8s:latest
docker push crkepler/multi-server-k8s-pgfix:latest
docker push crkepler/multi-worker-k8s:latest

docker push crkepler/multi-client-k8s:$SHA
docker push crkepler/multi-server-k8s-pgfix:$SHA
docker push crkepler/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=crkepler/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=crkepler/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=crkepler/multi-worker-k8s:$SHA
