Let's stand up a simple service to handle `Customer` data.

### The Build

We will change to the Apache Maven build.

```editor:open-file
file: ~/exercises/code/customers/pom.xml
```

This build includes dependencies for `R2DBC`, the `Wavefront` observability platform, `Reactive Web`, `Actuator`, `Lombok`, the `H2`, and `Java 11`.

### The Java Code

Let's look at the Java code. There are a few exciting players here. We'll need an entry point class.

```editor:open-file
file: ~/exercises/code/customers/src/main/java/com/example/customers/CustomersApplication.java
```

We're going to read and write data to a SQL database table called `customers`. We'll need an entity class.

```editor:open-file
file: ~/exercises/code/customers/src/main/java/com/example/customers/Customer.java
```

We'll need a Spring Data repository.

```editor:open-file
file: ~/exercises/code/customers/src/main/java/com/example/customers/CustomerRepository.java
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
cd ~/exercises/code/customers
mvn -f pom.xml clean spring-boot:run
```
Wait until the it finishes building and starts running. Then use the `curl` CLI to invoke the `/customers` HTTP endpoint and confirm that you're given some data in response.

```execute-2
curl localhost:8585/customers | jq -r
```

When you're done testing, stop the application. 

```terminal:interrupt
session: 1
```

```terminal:clear-all
```
