#!/bin/bash


envsubst < exercises/code/deploy/ingress.yaml.in > exercises/code/deploy/ingress.yaml
envsubst < exercises/code/deploy/customers.yaml.in > exercises/code/deploy/customers.yaml
envsubst < exercises/code/deploy/orders.yaml.in > exercises/code/deploy/orders.yaml
envsubst < exercises/code/deploy/gateway.yaml.in > exercises/code/deploy/gateway.yaml
