We're going to need both microservices running to verify that what we're about to build next will work.

In this section, we're going to build an edge service. An edge service is the first port-of-call, the first stop en route to the final destination, for requests destined for the downstream endpoints. An edge service sits between the outside world, and its many clients, and the downstream microservices. This central location makes it an ideal place in which to handle all sorts of requirements.

Each microservice must address non-functional, cross-cutting concerns like routing, compression, rate limiting, security, and observability. Spring Boot can handle some of this. Still, even trivial and minimally invasive concerns like rate limiting can become a maintenance burden at scale. An API gateway is a natural place in which to address some of these concerns centrally.

Let's stand up a simple edge service that is part API adapter and part API gateway.

### The Build

We'll need to make changes to the Apache Maven build.

```editor:open-file
file: ~/exercises/code/gateway/pom.xml
```

This build includes dependencies for the `Wavefront` observability platform, `RSocket`, `Actuator`, `Lombok`, `Reactive Web`, and `Java 11`.

### The Java Code

Let's look at the Java code. There are a few exciting players here. We'll need an entry point class.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/GatewayApplication.java
```

The gateway will connect to the HTTP and RSocket APIs. It'll be convenient to manipulate the responses in terms of the same types used to create the responses. We'll recreate the entities in the `customers` and `orders` modules as data transfer objects (DTOs) in this codebase.

Here's the `Order`:

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/Order.java
```

And here's the `Customer`:

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/Customer.java
```

We're going to provide a new view of the data, so we will need a DTO called `CustomerOrders`.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/CustomerOrders.java
```

Let's first look at building an API gateway. We'll use Spring Cloud Gateway to proxy one endpoint and forward requests onward to a downstream endpoint. Spring Cloud Gateway's contract is simple: given a bean of type `RouteLocator`, Spring Cloud Gateway will match the described routes in incoming requests, optionally process them in some way with filters, and then forward those requests onward.

You can factory those `Route` instances in several different ways. Here, we're going to use the convenient `RouteLocatorBuilder` DSL.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/ApiGatewayConfiguration.java
```

Our gateway defines one route that matches any request headed to the gateway's host and port (e.g.,: `http://localhost:9999/`) with a path (`/c`). Spring Cloud Gateway will forward the requests to the downstream `customers` service (running on `localhost:8585`). Filters sit in the middle of this exchange and change the request as it goes to the downstream service or the response as it returns from the downstream service.

An edge-service is also a natural place to introduce client translation logic or client-specific views. Clients often need specific views of data. They may require more awareness of the payloads going to and from a particular endpoint. We will create a new HTTP endpoint (`/cos`) in the `gateway` module that returns the materialized view of the combined data from the RSocket `orders` endpoint and the HTTP `orders` endpoint. We'll use reactive programming to handle the scatter-gather service orchestration and composition. The client need never know that the response contains data from two distinct data sources.

For HTTP interactions, we will configure an instance of the reactive, non-blocking `WebClient`. For RSocket interactions, we will configure an example of the reactive, non-blocking `RSocketRequester`. Note that because communication between RSocket nodes is bidirectional, it's not appropriate to think of one side as the _client_ and the other the _service_. Either side of an RSocket connection may act as either a client or a service. So, the framework provides the `RSocketRequester`, not the `RSocketClient`.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/ApiAdapterConfiguration.java
```

We use these two types - `RSocketRequester` and `WebClient` - to create a client to our various microservices, `CrmClient`.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/CrmClient.java
```

`CrmClient` offers three public methods. The first, `getCustomers`, calls the HTTP service and returns all the `Customer` records. The second method, `getOrdersFor`, returns all the `Order` records for a given `Customer`. The third method, `getCustomerOrders`, mixes both of these methods and provides a composite view. The fourth method, `applySlaDefaults`, uses `Flux<T>`'s operators to apply some useful defaults to all of our reactive streams. The stream will degrade gracefully if a request fails (`onErrorResume`). It will use a timeout (`timeout`) to abandon the request after a time interval has elapsed. The stream will retry (`retryWhen`) the request with a growing backoff period between subsequent attempts.

<!-- We'll need to stand up an HTTP endpoint that people can use to get the materialized view.  -->

Let's standup the HTTP endpoint for our materialized data.

```editor:open-file
file: ~/exercises/code/gateway/src/main/java/com/example/gateway/CustomerOrdersRestController.java
```

### The Configuration

The port and the logical name for each of the services vary. There are default values for the other services' host and ports (`gateway.orders.hostname-and-port` and `gateway.customers.hostname-and-port`) specified in `application.properties` that work on `localhost`, but that won't work in production. We'll need to override them when it comes time to deploy. Spring Boot supports [12-factor style configuration](https://12factor.net/config), so we will redefine default values in production (without recompiling the application binaries). We'll use a Kubernetes `ConfigMap` to define values exposed to the application as environment variables, overriding the default values defined in `application.properties`.

We want some values only to be active when a particular condition is met. We were going to use Spring's concept of a profile, a label that - once switched on - could result in some specific configuration being executed or activated. You can use labels to parameterize the application's runtime environment and execution in different environments (e.g.: `production`, `staging`, `dev`). We will run the `gateway` application with the `SPRING_PROFLES_ACTIVE` environment variable set to `cloud`. Our Spring-based gateway application will start up, see an environment variable indicating that a particular profile should be active, and then load the regular configuration _and_ the profile-specific configuration into one hierarchy of configuration values. In this case, the profile-specific configuration lives in `application-cloud.properties`.

```editor:append-lines-to-file
file: ~/exercises/code/gateway/src/main/resources/application-cloud.properties
text: |
    gateway.customers.hostname-and-port=http://${CUSTOMERS_SERVICE_SERVICE_HOST}:${CUSTOMERS_SERVICE_SERVICE_PORT}
    gateway.orders.hostname-and-port=tcp://${ORDERS_SERVICE_SERVICE_HOST}:${ORDERS_SERVICE_SERVICE_PORT}
```

