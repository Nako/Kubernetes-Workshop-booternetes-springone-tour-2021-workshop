Let's stand up a simple service to handle `Customer` data.

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
file: ~/exercises/code/customers/src/main/java/com/example/customers/CustomersListener.java
```

And, finally, we want to export an HTTP endpoint, `/customers`.

```editor:open-file
file: ~/exercises/code/customers/src/main/java/com/example/customers/CustomerRestController.java
```

### Go Time

Let's test it all out. Go to the root of the `customers` code and run:

```execute
command: cd ~/exercises/code/customers
```

```execute
command: mvn -f pom.xml clean spring-boot:run
```

Use the `curl` CLI to invoke the `/customers` HTTP endpoint and confirm that you're given some data in response.

```execute-2
command: curl localhost:8585/customers
```
