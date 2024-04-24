# Copyright 2015 The Prometheus Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Needs to be defined before including Makefile.common to auto-generate targets
hash = $(shell git rev-parse --short HEAD)
registry = ghcr.io/jacobbrewer1/mysqld_exporter
DATE = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

DOCKER_ARCHS ?= amd64 armv7 arm64

all: vet

include Makefile.common

STATICCHECK_IGNORE =

DOCKER_IMAGE_NAME ?= mysqld-exporter

.PHONY: test-docker-single-exporter
test-docker-single-exporter:
	@echo ">> testing docker image for single exporter"
	./test_image.sh "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" 9104

.PHONY: test-docker

clean:
	@echo "Cleaning up"
	# Remove the bin directory
	rm -rf bin

linux: clean
	@echo "Building for linux"
	GOOS=linux GOARCH=amd64 go build -o bin/app

docker: linux
	@echo "Building docker image"
	# Build the docker image
	docker build -t $(registry):$(hash) -t $(registry):latest .

ci: docker
	# Push the image to the registry
	docker push $(registry):$(hash) && docker push $(registry):latest
