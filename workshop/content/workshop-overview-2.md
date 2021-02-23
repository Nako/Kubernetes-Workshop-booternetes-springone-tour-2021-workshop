
You're going to build three microservices: two APIs and one API gateway. The two APIs will be technically very similar to each other. One microservice, the `customers` application, manages `Customer` data. The other microservice, the `orders` application, manages `Order` data. The `gateway` acts as a proxy and an edge service and addresses cross cutting concerns.

NOTE: There's a strong case that `order` data is part of the `customer` aggregate. I always like to imagine something like an `order` would endure even if the `customer` were to delete their records and orphan somehow the `orders` for revenue recognition purposes and fiscal reporting requirements. It would make more sense to tombstone the `order`, wouldn't it? This thinking informs why we've teased this domain into two different microservices.

Through consistency comes velocity. Spring Boot is an opinionated approach to the Java ecosystem that provides consistent defaults and easy-to-override features. We'll use Spring Boot to build a new Java application. You opt-in to a default configuration ("auto-config") for a particular feature (serving HTTP endpoints, data access, security, etc.) by adding so-called "starter" dependencies to the build. The mere presence of these starter dependencies on the classpath activates default features in the application.

Chris Richardson coined the pattern _microservice chassis_ to describe an opinionated, automatic framework like Spring Boot that reduces concerns for each new application.
