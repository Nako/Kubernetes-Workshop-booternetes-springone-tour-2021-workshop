Now let's stand up a simple service to handle `Order` data.

### The Build

We will change to the Apache Maven build.

```editor:open-file
file: ~/exercises/code/orders/pom.xml
```

This build includes dependencies for `R2DBC`, the `Wavefront` observability platform, `Reactive Web`, `Actuator`, `Lombok`, the `H2`, and `Java 11`.

### The Java Code

Let's look at the Java code. There are a few exciting players here. We'll need an entry point class.

```editor:open-file
file: ~/exercises/code/orders/src/main/java/com/example/orders/OrdersApplication.java
```

We're going to read and write data to a SQL database table called `orders`. We'll need an entity class.

```editor:open-file
file: ~/exercises/code/orders/src/main/java/com/example/orders/Order.java
```

We'll need a Spring Data repository.

```editor:open-file
file: ~/exercises/code/orders/src/main/java/com/example/orders/OrderRepository.java
```

We're going to read and write data to a SQL database table called `orders`. The H2 SQL database is an embedded, in-memory SQL database that will lose its state on every restart. We'll need to initialize it.

```editor:open-file
file: ~/exercises/code/orders/src/main/java/com/example/orders/OrdersListener.java
```

And, finally, we want to export an RSocket endpoint, `/orders`.

```editor:open-file
file: ~/exercises/code/orders/src/main/java/com/example/orders/OrdersRSocketController.java
```

### Go Time

Let's test it all out. Go to the root of the `orders` code and run:

```execute
cd ~/exercises/code/orders
mvn -f pom.xml clean spring-boot:run
```

Use the `rsc` CLI to invoke the `/orders` RSocket endpoint and confirm that you're given some data in response.

```execute-2
rsc tcp://localhost:8181 -r orders.3 --stream | jq -r
```

When you're done testing, stop the application.

```terminal:interrupt
session: 1
```

```terminal:clear-all

```
