[![Circle CI](https://circleci.com/gh/codeworksio/docker-streaming-server.svg?style=shield "CircleCI")](https://circleci.com/gh/codeworksio/docker-streaming-server)&nbsp;[![Size](https://images.microbadger.com/badges/image/codeworksio/streaming-server.svg)](http://microbadger.com/images/codeworksio/streaming-server)&nbsp;[![Version](https://images.microbadger.com/badges/version/codeworksio/streaming-server.svg)](http://microbadger.com/images/codeworksio/streaming-server)&nbsp;[![Commit](https://images.microbadger.com/badges/commit/codeworksio/streaming-server.svg)](http://microbadger.com/images/codeworksio/streaming-server)&nbsp;[![Docker Hub](https://img.shields.io/docker/pulls/codeworksio/streaming-server.svg)](https://hub.docker.com/r/codeworksio/streaming-server/)

Docker Streaming Server
=======================

?

Installation
------------

Builds of the image are available on [Docker Hub](https://hub.docker.com/r/codeworksio/streaming-server/).

    docker pull codeworksio/streaming-server

Alternatively you can build the image yourself.

    docker build --tag codeworksio/streaming-server \
        github.com/codeworksio/docker-streaming-server

Quickstart
----------

Start container using:

    docker run --detach --restart always \
        --name streaming-server \
        --hostname streaming-server \
        --publish 1935:1935 \
        codeworksio/streaming-server

See
---

- [OBS post](https://obsproject.com/forum/resources/how-to-set-up-your-own-private-streaming-server-server-using-nginx.50/)
- [tiangolo/nginx-streaming-server-docker](https://github.com/tiangolo/nginx-streaming-server-docker)
