# docker
Docker container for variation example

This docker container checks out and compiles the two variation-service and variation-frontend web apps. It also launches a tomcat instance that serves the two apps.

Tomcat is running at port 8080, as such it needs to enabled when running the image.

```sudo docker run -d -p 8080:8080 -p 8009:8009 -td variation-andreas```

after this, there two apps will be available from:

```http://localhost:8888/variation-service/``` 

(note: it contains the beginnings of a web-frontend that documents the REST backend).

and

```http://localhost:8888/variation-frontend/```



# Comments
This is the first time I am using docker containers, as such it is quite possible that there is a better way of doing this.

