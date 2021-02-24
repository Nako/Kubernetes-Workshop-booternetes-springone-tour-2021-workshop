We've sort of eschewed the question of observability. Observability is the idea that we can understand the state of a system by observing its outputs.

For low cardinality data - e.g., the number of requests to a given URL, the number of orders made, and the number of customers signed up - metrics are a natural fit. Metrics are just numbers mapped to a logical name. They're statistics like the total, the average, the median value, the 95th percentile. You can use [Micrometer](http://micrometer.io) to capture this kind of data. Spring Boot's Actuator module integrates Micrometer to capture all sorts of useful metrics out of the box. You can use Micrometer to capture your metrics - key performance indicators (KPIs) - directly.

The Spring Boot Actuator is a set of managed HTTP endpoints that expose useful information about an application, like metrics, health checks, and the current environment. After all, whom better to articulate the state of a given service than the service itself?

Once added to the `application.properties` files of all three modules, the following properties expand the data exposed from the Actuator endpoints.

```editor:append-lines-to-file
file: ~/exercises/code/customers/src/main/resources/application.properties
text: |
    management.endpoints.web.exposure.include=*
    management.endpoint.health.probes.enabled=true
    management.endpoint.health.show-details=always
    management.health.probes.enabled=true
```

```editor:append-lines-to-file
file: ~/exercises/code/orders/src/main/resources/application.properties
text: |
    management.endpoints.web.exposure.include=*
    management.endpoint.health.probes.enabled=true
    management.endpoint.health.show-details=always
    management.health.probes.enabled=true
```

```editor:append-lines-to-file
file: ~/exercises/code/gateway/src/main/resources/application.properties
text: |
    management.endpoints.web.exposure.include=*
    management.endpoint.health.probes.enabled=true
    management.endpoint.health.show-details=always
    management.health.probes.enabled=true
```

```editor:append-lines-to-file
file: ~/exercises/code/gateway/src/main/resources/application-cloud.properties
text: |
    management.endpoints.web.exposure.include=*
    management.endpoint.health.probes.enabled=true
    management.endpoint.health.show-details=always
    management.health.probes.enabled=true
```

Once you've applied the configuration, you can restart the customer service as an example to see what happens.

```execute
cd ~/exercises/code/customers
mvn clean spring-boot:run

```

Let's check out what endpoints have been added.

```execute-2
curl localhost:8585/actuator | jq -r
```

We can see the metrics information here:

```execute-2
curl localhost:8585/actuator/metrics | jq -r
```

And the health endpoint for Kubernetes liveness and readiness probes

```execute-2
curl localhost:8585/actuator/health | jq -r
```

And this will show us the application's environment variables.

```execute-2
curl localhost:8585/actuator/env | jq -r
```

These are only a sampling of the endpoints and opportunities that Spring Boot Actuator represents.

When you're done testing, stop the application.

```terminal:interrupt
session: 1
```

```terminal:clear-all

```
