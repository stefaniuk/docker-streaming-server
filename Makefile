TARGETS := $(shell cat $(realpath $(lastword $(MAKEFILE_LIST))) | grep "^[a-z]*:" | awk '{ print $$1; }' | sed 's/://g' | grep -vE 'all|help' | paste -sd "|" -)
NAME := $(subst docker-,,$(shell basename $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))))
IMAGE := $(shell basename $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))/..)))/$(NAME)

all: help

help:
	echo
	echo "Usage:"
	echo
	echo "    make $(TARGETS) [APT_PROXY|APT_PROXY_SSL=ip:port]"
	echo

build:
	docker build \
		--build-arg APT_PROXY=${APT_PROXY} \
		--build-arg APT_PROXY_SSL=${APT_PROXY_SSL} \
		--build-arg VERSION=$(shell cat VERSION) \
		--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
		--build-arg VCS_URL=$(shell git config --get remote.origin.url) \
		--tag $(IMAGE):$(shell cat VERSION) \
		--rm .
	docker tag $(IMAGE):$(shell cat VERSION) $(IMAGE):latest
	docker rmi --force $$(docker images | grep "<none>" | awk '{ print $$3 }') 2> /dev/null ||:

start:
	docker stop $(IMAGE) > /dev/null 2>&1 ||:
	docker rm $(IMAGE) > /dev/null 2>&1 ||:
	docker run --detach --interactive --tty \
		--name $(NAME) \
		--hostname $(NAME) \
		--volume $(shell pwd)/mounts/var/lib/streaming:/var/lib/streaming \
		--publish 1935:1935 \
		--publish 8080:8080 \
		--publish 8443:8443 \
		$(IMAGE)

stop:
	docker stop $(NAME)

log:
	docker logs --follow $(NAME)

test:
	docker exec --interactive --tty \
		--user "ubuntu" \
		$(NAME) \
		ps auxw

bash:
	docker exec --interactive --tty \
		$(NAME) \
		/bin/bash --login ||:

clean:
	docker stop $(NAME) > /dev/null 2>&1 ||:
	docker rm $(NAME) > /dev/null 2>&1 ||:

remove: clean
	docker rmi $(IMAGE):$(shell cat VERSION) > /dev/null 2>&1 ||:
	docker rmi $(IMAGE):latest > /dev/null 2>&1 ||:

push:
	docker push $(IMAGE):$(shell cat VERSION)
	docker push $(IMAGE):latest
	curl --request POST "https://hooks.microbadger.com/images/$(IMAGE)/o6WEpIkU6QkdRAOuZ9EcPx6djOo="

.SILENT:
