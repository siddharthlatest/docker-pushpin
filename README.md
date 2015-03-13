# docker-pushpin
The Dockerfile for running pushpin(http://pushpin.org) using Docker

To build:

docker build --tag="pushpin" . in the folder

To start:

docker run --name pushpin -d -p 7999:7999 -p 5561:5561 pushpin

It listens for connections on port 8080 of host.