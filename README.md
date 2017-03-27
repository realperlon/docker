# docker
Docker container for variation example

This docker container checks out and compiles the two [variation-service](https://github.com/realperlon/variation-service) and [variation-frontend](https://github.com/realperlon/variation-frontend) web apps. It also launches a tomcat instance that serves the two apps.

## How to launch
Tomcat is running at port 8080, as such it needs to enabled when running the image.

```sudo docker run -d -p 8080:8080 -p 8009:8009 -td realperlon/variation-andreas```

after this, the two apps will be available from:

```http://localhost:8888/variation-service/``` 

(note: it contains the beginnings of a web-frontend that documents the REST backend).

and

```http://localhost:8888/variation-frontend/```

## Memory requirements
For the container to run well, it requires Docker to have at least 4G of RAM available.

## Comments
This is the first time I am using docker containers, as such it is quite possible that there is a better way of doing this.

## Possible next steps
* Figure out how to make the create docker image smaller


