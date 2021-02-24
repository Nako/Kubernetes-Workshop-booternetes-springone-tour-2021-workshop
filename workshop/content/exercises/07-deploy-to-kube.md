
Let's look at deploying our newly minted containers and running them in Kubernetes. We could craft a ton of YAML and then apply that. We'll write some YAML to get a container up and running in production in no time. The only wrinkle is that our applications will need to change specific values based on environment variables in the container.

We're going to need to apply three different Kubernetes configuration files, `customers.yaml`, `orders.yaml`, and `gateway.yaml`.

Here are those files. First, we'll look at the `orders` service.

```editor:open-file
file: ~/exercises/code/deploy/orders.yaml
```

And then the `customers` service.

```editor:open-file
file: ~/exercises/code/deploy/customers.yaml
```

and then finally, the `gateway` code.

```editor:open-file
file: ~/exercises/code/deploy/gateway.yaml
```

We also have an `ingress` resource that will allow you to connect directly to the gateway service.

```editor:open-file
file: ~/exercises/code/deploy/ingress.yaml
```

We can deploy all those components deployed by running `kubectl`.

```execute
kubectl apply -f ~/exercises/code/deploy/orders.yaml
kubectl apply -f ~/exercises/code/deploy/customers.yaml
kubectl apply -f ~/exercises/code/deploy/gateway.yaml
kubectl apply -f ~/exercises/code/deploy/ingress.yaml
```

Now lets see what we've deployed.

```execute-2
kubectl get all
```
