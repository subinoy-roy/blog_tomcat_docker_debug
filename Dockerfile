# 1) getting base image form ubuntu
FROM ubuntu
MAINTAINER Subinoy Roy <subinoyroy@gmail.com>

# 2) run update
RUN apt-get update

# 3) install openjdk8
RUN apt-get -y install openjdk-8-jdk

# 4) install wget for downloading the tomcat tarball
RUN apt-get install -y wget

# 5) Create a directory /usr/local/tomcat and /usr/local/tomcat/conf
RUN mkdir /usr/local/tomcat
RUN mkdir /usr/local/tomcat/conf

# install tomcat.
# 6) get the tarball and put it into /tmp/
RUN wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.53/bin/apache-tomcat-8.5.53.tar.gz -O /tmp/tomcat.tar.gz
# 7) go to /tmp/ and extract the tarball
RUN cd /tmp && tar xvfz tomcat.tar.gz
# 8) Copy the extracted stuffs into /usr/local/tomcat/
RUN cp -Rv /tmp/apache-tomcat-8.5.53/* /usr/local/tomcat/

# 9) tomcat-users.xml sets up user accounts for the Tomcat manager GUI
# and script access for Maven deployments
ADD tomcat-users.xml /usr/local/tomcat/conf/
ADD context.xml /usr/local/tomcat/webapps/manager/META-INF

# 10) add tomcat jpda debugging environmental variables
ENV JPDA_ADDRESS="8000"
ENV JPDA_TRANSPORT="dt_socket"

# 11) expose 8080 port
EXPOSE 8080

# 12) Add the target war from local directory to the container
ADD demoservice/target/demoservice.war /usr/local/tomcat/webapps/

# run Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "jpda", "run"]