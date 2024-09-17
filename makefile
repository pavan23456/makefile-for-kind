# Variables
CLUSTER_NAME=kind-cluster
KIND_CONFIG=pavan.yaml
INGRESS_CONTROLLER_MANIFEST=https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
 
# Target: Create the kind cluster with 2 nodes
.PHONY: create-cluster
create-cluster:
	@echo "Creating Kind cluster with 1 control-plane and 1 worker..."
	kind create cluster --name $(CLUSTER_NAME) --config=$(KIND_CONFIG)
 
# Target: Install nginx-ingress-controller
.PHONY: install-ingress
install-ingress:
	@echo "Installing nginx ingress controller..."
	kubectl apply -f $(INGRESS_CONTROLLER_MANIFEST)
 
# Target: Delete the kind cluster
.PHONY: destroy-cluster
destroy-cluster:
	@echo "Destroying Kind cluster..."
	kind delete cluster --name $(CLUSTER_NAME)
 
# Target: Recreate everything (clean slate)
.PHONY: recreate
recreate: destroy-cluster create-cluster install-ingress
	@echo "Cluster and nginx ingress controller set up from scratch!"
 
# Target: Clean up dangling resources (if necessary)
.PHONY: clean
clean:
	@echo "Cleaning up dangling Kubernetes resources..."
	kubectl delete pod --all --namespace ingress-nginx || true

# Target: Verify the setup
.PHONY: verify
verify:
	@echo "Verifying Kind cluster and ingress controller setup..."
	kubectl get nodes
	kubectl get pods --all-namespaces 
