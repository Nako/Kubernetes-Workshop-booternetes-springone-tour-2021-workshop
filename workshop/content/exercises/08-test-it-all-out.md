
### Go Time

Let's test it all out. Go to the root of the `gateway` code and run:

```dashboard:open-url
url: http://gateway-${SESSION_NAMESPACE}.${INGRESS_DOMAIN}/cos
```


```execute
cd ~/exercises/code/gateway
mvn clean spring-boot:run

```

Use the `curl` CLI to invoke the `/cos` HTTP endpoint.

```execute-2
curl localhost:9999/cos
```

You should be staring at JSON containing both your customer data and the orders for each customer. Congratulations!

When you're done testing, stop the application.

```terminal:interrupt
session: 1
```

```terminal:clear-all

```
