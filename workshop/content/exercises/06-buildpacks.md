
We've got three microservices, and we need to get them to the cloud. For anybody reading this Eduk8s course, the _cloud_ means containers, and it means Kubernetes. We'll need containerized versions of each of our applications. Don't freak out! I didn't say we're going to write a `Dockerfile`; I said we need to put our applications into containers. _ There's a difference_. 

We'll use [buildpacks](https://buildpacks.io/) to transform application source code into images that can run on any cloud. Buildpacks take an opinionated approach to containerizing applications. How many different shapes could your Spring Boot, Django, Vue.js, .NET MVC, or Laravel projects have? How many different shapes does _any_ application have? In  Java, application binaries commonly come in two shapes:  there are `.war` artifacts (deployed in a Servlet container) and so-called "fat" `.jar` artifacts (run with `java`). So, not that many, we'd reckon. A buildpack codifies the recipe for taking arbitrary applications of well-known shapes from different languages and runtimes and turning them into containers. A buildpack will analyze the source code or source artifact that we give it and then create a filesystem with sensible defaults that the buildpack will containerize. A Spring Boot "fat" `.jar`   ends up with a Java runtime and sensibly configured memory pools. A client-side Vue.js application might land in an Nginx server serving static assets.  Whatever the result, you can then take that container and tag it in Docker, and then push it to your container registry of choice. So, let's. 

First Lets build and push the customer image.

```execute
cd ~/exercises/code/customers
mvn -f pom.xml \
    -DskipTests=true \
    clean spring-boot:build-image -e \
    -Dspring.profiles.active=production,cloud \
    -Dspring-boot.build-image.imageName=$REGISTRY_HOST/customers
docker push $REGISTRY_HOST/customers
```

Now the orders image.

```execute
cd ~/exercises/code/orders
mvn -f pom.xml \
    -DskipTests=true \
    clean spring-boot:build-image -e \
    -Dspring.profiles.active=production,cloud \
    -Dspring-boot.build-image.imageName=$REGISTRY_HOST/orders
docker push $REGISTRY_HOST/orders
```

Now the gateway image.

```execute
cd ~/exercises/code/gateway
mvn -f pom.xml \
    -DskipTests=true \
    clean spring-boot:build-image -e \
    -Dspring.profiles.active=production,cloud \
    -Dspring-boot.build-image.imageName=$REGISTRY_HOST/gateway
docker push $REGISTRY_HOST/gateway
```

Now we have all three images in our registry, and we're ready to deploy them with kubernetes.
