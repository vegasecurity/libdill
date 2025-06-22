#!/bin/sh

docker build -t libdill-webapp . && docker run -it --rm -p 8080:8080 -p 8081:8081 libdill-webapp
