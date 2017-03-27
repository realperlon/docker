FROM tomcat:7-jre8  
MAINTAINER Andreas Prlic <andreas.prlic@gmail.com>

################

# Install dependencies
RUN apt-get update && apt-get install -y git build-essential curl wget software-properties-common


################
# Install openjdk

# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean;

# Fix certificate issues, found as of
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
	apt-get install ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f;

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME


################
##### We are using Maven to build 2 java projects into war files.
##### The two war files then get deployed using tomcat
#####
################

# Taken from https://github.com/carlossg/docker-maven/blob/33eeccbb0ce15440f5ccebcd87040c6be2bf9e91/jdk-8/Dockerfile
# (AFAIK there is no multiple inheritance in docker)

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

RUN ["chmod", "+x", "/usr/local/bin/mvn-entrypoint.sh"]

VOLUME "$USER_HOME_DIR/.m2"

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]

################

# Now build my own war files

ARG APPDIR=/usr/src/app
ARG WEBAPPS=/usr/local/tomcat/webapps/

RUN mkdir -p $APPDIR

# The RESTful server
RUN git clone https://github.com/realperlon/variation-service.git $APPDIR/variation-service
RUN cd $APPDIR/variation-service && pwd && mvn package

# The frontend
RUN git clone https://github.com/realperlon/variation-frontend.git $APPDIR/variation-frontend
RUN cd $APPDIR/variation-frontend && pwd && mvn package

################

# deploy using tomcat

EXPOSE 8080
RUN rm -fr $WEBAPPS/ROOT

run cd $APPDIR/variation-service/target/ && ls
RUN cp $APPDIR/variation-service/target/variation-service.war $WEBAPPS
RUN cp $APPDIR/variation-frontend/target/variation-frontend.war $WEBAPPS

CMD ["catalina.sh", "run"]
