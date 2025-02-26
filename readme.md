# Couchbase Cluster Setup on Kubernetes (K8s)

## 🚀 Quick Start

Follow these steps to set up a Couchbase Cluster on Kubernetes.

---

## 📦 1. Create a Namespace *(Recommended)*

It is recommended to create a dedicated namespace for the Couchbase installation. This approach helps keep the Kubernetes environment organized and simplifies resource management.

```bash
kubectl create namespace couchbase
```

✅ This command creates a dedicated namespace named `couchbase`.

---

## 🛠️ 2. Install Couchbase Operator

### a. Install Custom Resource Definitions (CRDs)
The first step is to install the CRDs that define Couchbase resource types:

```bash
kubectl -n couchbase create -f ./crd.yaml
```

✅ This command registers the necessary Couchbase CRDs in the Kubernetes cluster.

### b. Deploy the Couchbase Operator
Deploy the admission controller and the operator:

```bash
./bin/cao create admission --namespace couchbase
./bin/cao create operator --namespace couchbase
```

✅ These commands install the Couchbase Operator in the `couchbase` namespace.

### c. Verify Deployment
Check if the deployments are running:

```bash
kubectl -n couchbase get deployments
```

✅ You should see the Couchbase Operator deployment running.

---

## 📄 3. Deploy the Couchbase Cluster

Create a `CouchbaseCluster` configuration file, then apply it with:

```bash
kubectl -n couchbase apply -f couchbase-cluster.yaml
```

✅ This command creates the Couchbase cluster in the specified namespace.

### Check Pod Status
Monitor the newly created pods:

```bash
kubectl get pods -n couchbase
```

✅ Pods should transition to a `Running` state.

---

## 🌐 4. Access the Couchbase UI

### a. Port Forwarding (Foreground)
Forward the Couchbase UI port to access it via browser:

```bash
kubectl port-forward cb-example-0000 8091 -n couchbase
```

✅ Access the UI at `http://localhost:8091`.

### b. Port Forwarding (Background)
To keep the port forwarding running in the background:

```bash
nohup kubectl port-forward svc/cb-example-ui 8091 -n couchbase > port-forward.log 2>&1 &
```

✅ Logs are saved in `port-forward.log`.

---

## 🧹 5. Cleanup and Teardown

### a. Delete the Couchbase Cluster
Remove the deployed Couchbase cluster:

```bash
kubectl delete -f couchbase-cluster.yaml -n couchbase
```

✅ This command deletes all Couchbase resources in the namespace.

### b. Stop Background Port Forwarding
Terminate any background port-forwarding processes:

```bash
pkill -f "kubectl port-forward"
```

✅ Port forwarding is stopped and background processes are terminated.

---

## ✅ Result

After completing these steps, your Couchbase cluster will be fully deployed and accessible on Kubernetes, ready for use!

