SHELL := /bin/bash

DOCKER_REGISTRY ?= centos7.internal:5000
IMAGE ?= hello-kubernetes

# Check for required binaries
EXECUTABLES = git podman tar
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
  TAG=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
else
  TAG=${GIT_COMMIT_SHORT}
endif

.PHONY: all login build scan tag push clean
all: |login build tag scan push

login:
	@echo "${DOCKERHUB_TOKEN}" | podman login --username "${DOCKERHUB_USERNAME}" --password-stdin docker.io

build:
	podman build --format docker -t ${DOCKER_REGISTRY}/${IMAGE}:${TAG} .

scan:
	$(eval TMP_DIR := $(shell mktemp -d))
	podman image save --quiet --format docker-archive ${DOCKER_REGISTRY}/${IMAGE}:${TAG} | tar -x --wildcards -C ${TMP_DIR} --warning=no-timestamp
	@find ${TMP_DIR} -type f -name '*.tar' -print0 | xargs -r -0 --max-args=1 tar -C ${TMP_DIR} --warning=no-timestamp -xf
	@trivy fs --exit-code 0 --no-progress --format json --output results.json ${TMP_DIR}
	@rm -rf ${TMP_DIR}

tag:
	podman tag ${DOCKER_REGISTRY}/${IMAGE}:${TAG} ${DOCKER_REGISTRY}/${IMAGE}:latest

push:
	podman push ${DOCKER_REGISTRY}/${IMAGE}:${TAG}
	podman push ${DOCKER_REGISTRY}/${IMAGE}:latest

clean:
	podman rmi ${DOCKER_REGISTRY}/${IMAGE}:${TAG} || true
	podman rmi ${DOCKER_REGISTRY}/${IMAGE}:latest || true
