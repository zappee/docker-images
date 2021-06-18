# Oracle Java 8 Docker Image

This image can only be used as a base image of another images.
Despite this fact, if you would like to deploy this Java 8 image and see what is in it then use the following commands:

* Run the image
    * `docker run --name java-8 -d java-8:1.0.0 tail -f /dev/null`

* Login into the running container
    * as an ordinary user: `docker exec -it java-8 /bin/bash`
    * as root: `docker exec -it -u root -w /root java-8 /bin/bash`
