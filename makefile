# Create the kind cluster
create-cluster:
	kind create cluster --name challenge2-cluster

# Delete the kind cluster
delete-cluster:
	kind delete cluster --name challenge2-cluster

# Deploy MySQL and WordPress
apply: apply-mysql apply-wordpress
	@echo "WordPress and MySQL deployed successfully."

apply-mysql:
	kubectl apply -f mysql-statefulset.yaml
	kubectl apply -f mysql-secret.yaml
	kubectl apply -f mysql-pv-pvc.yaml
	kubectl apply -f mysql-service.yaml

apply-wordpress:
	kubectl apply -f wordpress-deployment.yaml
	kubectl apply -f wordpress-pv-pvc.yaml

# Delete MySQL and WordPress
delete: delete-mysql delete-wordpress
	@echo "WordPress and MySQL deleted successfully."

delete-mysql:
	kubectl delete -f mysql-statefulset.yaml
	kubectl delete -f mysql-secret.yaml
	kubectl delete -f mysql-pv-pvc.yaml
	kubectl delete -f mysql-service.yaml

delete-wordpress:
	kubectl delete -f wordpress-deployment.yaml
	kubectl delete -f wordpress-pv-pvc.yaml

# Port-forward WordPress to access it locally
port-forward:
	kubectl port-forward service/wordpress-service 8080:80

