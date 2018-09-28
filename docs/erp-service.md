## Project ERP System

This is microservice implementation of a basic ERP system. 

## Getting started

After cloning the repository :

```bash
    git clone https://github.com/esna-security/simense-erp-service.git
    cd simense-erp-service
```

to quickly get started and initialize the development environment, use the project runner command :

```bash
    ./runner.sh init 
```

which will install its dependencies (including a PostgreSQL docker container)

Then use runner command:
```bash
   ./runner.sh dev
```
Or you can start dev runner with loading the test data:
```bash
   ./runner.sh dev loadData
```
and immediately give you access to [the api](http://localhost:8080/swagger-ui.html) in development mode.

Also you can run tests with runner command:
```bash
   ./runner.sh test
```

### Application configuration 

The application is currently configured for the following environments : dev, test, prod. 

For dev/test environments configuration are specified in resources.

For prod environment you should create file `processor.properties` on the file system and specify a path to directory during start the application.
For example `-Dprop.path=/DATA/config/`

IMPORTANT: all properties can be overloaded via the system variables. For example `server.port` can be overloaded by the system variable `SERVER_PORT`

### Properties
Application properties
```properties
server.port=8080
prop.path=... #path to properties on the file system
```

Jwt properties
```properties
security.jwt.uri=/v1/auth/**
security.jwt.header=Authorization
security.jwt.prefix=Bearer 
security.jwt.expiration=...
security.jwt.secret=...
security.jwt.admin.password=...
```

PostgreSQL properties
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/assets-dev   // this is database connection url
spring.datasource.username=assets                                   // this is the username for postgresql
spring.datasource.password=12345                                    // this is the password for db
spring.jpa.hibernate.ddl-auto=create                                // this property means if no table is existed the one will be created
spring.jpa.database=postgresql                                      // initialisation db
``` 

### Logging

You can override the default application logging. If you want to do this, you should create(or use existing logback.xml configuration file)
then add the environment variable `LOGGING_CONFIG` with value a path to logback configuration file.
For AWS CloudWatch you can set `LOGGING_CONFIG` with value `classpath:logback-aws.xml` but you should configure it with you data(see [docs](https://github.com/j256/cloudwatch-logback-appender)).
This file is located `core/src/main/resources/logback-aws.xml`. 

Important: Logback configuration supports the environment variables inside the file.

If you want to add the file appender just specify the environment variable `LOG_FILE`. For example `export LOG_FILE=./logs/erp.log`

Logback configuration example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <property name="LOG_FILE" value="./logs/erp.log"/>  <!-- path to log file-->

    <include resource="org/springframework/boot/logging/logback/base.xml"/> <!-- base spring logback configuration CONSOLE/FILE appender-->

    <logger name="org.springframework.web" level="INFO"/>
    <logger name="com.erp" level="DEBUG"/>
</configuration>
```

### PostgreSQL docker
PostgreSQL is dockerized. You can see it by the following path `docker/postgres`. 
See the default environment variables by the path `docker/postgres/env.postgres`. 
And see the initial sql script `docker/postgres/init.sql`
```
POSTGRES_USER: assets                   // postgres user name
POSTGRES_PASSWORD: 12345                // postgres password
```
Also, please look at the docker-compose file `docker/docker-compose`.
If you want to change some properties, remember that this values are used in the application, 
so you also need to change values in the application.

## Workflow
To use the application API you must be authorized.

Application provides base credentials authentication via password that are defined in properties. 
Property `security.jwt.admin.password` is responsible for the authentication. The default password(for dev environment) is `pass`
 
### Authentication workflow
Do `POST` call API `{host:port}/v1/auth` with body:
```json
{
  "password": "..."
}
```
if password is matched then jwt token will be returned with expiration(in seconds) in response:
```json
{
  "token": "....",
  "expiration": 1000
}
```
Then the header with composite value `{prefix}token` should be added to each API call. Header is defined in property `security.jwt.header`. 
Prefix that is also defined in property `security.jwt.prefix`.
For example there are properties:
```properties
security.jwt.header=Authorization
security.jwt.prefix=Bearer 
``` 
API call should be done with header `Authorization` and with value `Bearer token`

##  Local development

### Running the service with development profile   

running the application with development profile :
```bash
    ./gradlew :core:bootRun -Dspring.profiles.active=dev --no-daemon
```
running the application with development profile and load test data :
```bash
    ./gradlew :core:bootRun -Dspring.profiles.active=dev -DloadData=true --no-daemon
```

### Running the service tests  

The service is covered with unit, integration and full BDD tests

running unit tests :

```bash
   ./gradlew :core:test --no-daemon
```

running integration tests:

```bash
   ./gradlew :integration-test:test --no-daemon
```

running the tests (all tests: unit tests and integration tests):

```bash
   ./gradlew test --no-daemon
```

## Release management  


## Api Documentation  

A swagger api documentation is available through visiting the documentation url at :

    {host:port}/swagger-ui.html 

## HAL Browser  

A HAL browser is available through visiting the documentation url at :
```
{host:port}/browser/index.html#/
```
You must be authorized to use HAL browser API. Check `Authentication workflow`