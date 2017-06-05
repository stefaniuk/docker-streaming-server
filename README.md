[![Circle CI](https://circleci.com/gh/codeworksio/docker-rtmp.svg?style=shield "CircleCI")](https://circleci.com/gh/codeworksio/docker-rtmp)&nbsp;[![Size](https://images.microbadger.com/badges/image/codeworksio/rtmp.svg)](http://microbadger.com/images/codeworksio/rtmp)&nbsp;[![Version](https://images.microbadger.com/badges/version/codeworksio/rtmp.svg)](http://microbadger.com/images/codeworksio/rtmp)&nbsp;[![Commit](https://images.microbadger.com/badges/commit/codeworksio/rtmp.svg)](http://microbadger.com/images/codeworksio/rtmp)&nbsp;[![Docker Hub](https://img.shields.io/docker/pulls/codeworksio/rtmp.svg)](https://hub.docker.com/r/codeworksio/rtmp/)

Docker RTMP
====================

?

Installation
------------

Builds of the image are available on [Docker Hub](https://hub.docker.com/r/codeworksio/rtmp/).

    docker pull codeworksio/rtmp

Alternatively you can build the image yourself.

    docker build --tag codeworksio/rtmp \
        github.com/codeworksio/docker-rtmp

Quickstart
----------

Start container using:

    docker run --detach --restart always \
        --name rtmp \
        --hostname rtmp \
        --publish 1935:1935 \
        codeworksio/rtmp

See
---

- [OBS post](https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/)
- [tiangolo/nginx-rtmp-docker](https://github.com/tiangolo/nginx-rtmp-docker)
