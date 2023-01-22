# Usage:
# make        # compile all binary
# make clean  # remove ALL binaries and objects

AUTHOR                     ?= issenn

PACKAGE_NAME               ?= dnsmasq-china-list
PACKAGE_GIT_REF            ?=
PACKAGE_VERSION            ?=
PACKAGE_VERSION_PREFIX     ?=
PACKAGE_HEAD               ?= false
ifndef PACKAGE_GIT_REF
    PACKAGE_GIT_REF        := master
endif
ifeq ($(PACKAGE_HEAD), true)
    PACKAGE_GIT_REF        := master
endif
PACKAGE_URL                ?= https://github.com/felixonmars/dnsmasq-china-list
PACKAGE_SOURCE_URL         ?= https://github.com/felixonmars/dnsmasq-china-list/archive/$(PACKAGE_GIT_REF).tar.gz
PACKAGE_HEAD_URL           ?= https://github.com/felixonmars/dnsmasq-china-list.git
DEBUG                      ?= false

PACKAGE_DNS_SERVER         ?= 119.29.29.29,223.5.5.5
PACKAGE_DNS_CONFIG_TYPE    ?= dnscrypt-proxy
PACKAGE_DNS_CONFIG_NAME    ?= dnscrypt-proxy-forwarding-rules.txt

GIT_CLONE_FLAGS            ?=

PROXY                      ?= socks5://10.0.0.131:10810
NO_PROXY                   ?= localhost,127.0.0.1,10.0.0.102:3000
USE_PROXY                  ?= false

# Docker
DOCKER_VERSION             := $(shell docker --version)

CACHEBUST                  ?= https://api.github.com/repos/felixonmars/dnsmasq-china-list/git/refs/heads/master

ifeq ($(DEBUG), true)
    CACHEBUST              := http://date.jsontest.com
endif

DOCKER_BUILD_FLAGS         ?=

ifeq ($(USE_PROXY), true)
    DOCKER_BUILD_FLAGS     += --build-arg HTTP_PROXY="$(PROXY)" --build-arg HTTPS_PROXY="$(PROXY)" --build-arg NO_PROXY="$(NO_PROXY)"
endif

DOCKER_BUILD_NO_CACHE      ?= false
ifeq ($(DOCKER_BUILD_NO_CACHE), true)
    DOCKER_BUILD_FLAGS     += --no-cache=true --build-arg CACHEBUST="${CACHEBUST}"
endif

DOCKER_BUILDKIT            ?= true
BUILDKIT_PROGRESS          ?= auto  # auto / plain

default: all
	@echo 'Run `make options` for a list of all options'

options: help
	@echo
	@echo 'Options:'
	@echo 'DOCKER = $(DOCKER_VERSION)'
    # @echo 'DOCDIR = $(DOCDIR)'
    # @echo 'DESTDIR = $(DESTDIR)'

help:
	@echo 'make:                 Test and compile.'
	@echo 'make clean:           Remove the compiled files'

all: build

.PHONY : debug
debug:
	env USE_PROXY=true BUILDKIT_PROGRESS=plain PACKAGE_HEAD=off DOCKER_BUILD_NO_CACHE=true GIT_CLONE_FLAGS=" --depth=1" DEBUG=true make

build:
	env DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) BUILDKIT_PROGRESS=$(BUILDKIT_PROGRESS) \
	    docker build $(DOCKER_BUILD_FLAGS) \
	        --target artifact \
	        --output type=local,dest=. \
	        --build-arg GIT_CLONE_FLAGS="$(GIT_CLONE_FLAGS)" \
	        --build-arg PACKAGE_NAME="$(PACKAGE_NAME)" \
	        --build-arg PACKAGE_GIT_REF="$(PACKAGE_GIT_REF)" \
	        --build-arg PACKAGE_VERSION="$(PACKAGE_VERSION)" \
	        --build-arg PACKAGE_VERSION_PREFIX="$(PACKAGE_VERSION_PREFIX)" \
	        --build-arg PACKAGE_DNS_SERVER="$(PACKAGE_DNS_SERVER)" \
	        --build-arg PACKAGE_DNS_CONFIG_TYPE="$(PACKAGE_DNS_CONFIG_TYPE)" \
	        --build-arg PACKAGE_DNS_CONFIG_NAME="$(PACKAGE_DNS_CONFIG_NAME)" \
	        --build-arg PACKAGE_HEAD_URL="$(PACKAGE_HEAD_URL)" \
	        --build-arg PACKAGE_HEAD="$(PACKAGE_HEAD)" \
	        --build-arg PACKAGE_URL="$(PACKAGE_URL)" \
	        --build-arg PACKAGE_SOURCE_URL="$(PACKAGE_SOURCE_URL)" \
	        -f Dockerfile .

test:

compile:

clean:
	@echo "Cleaning up..."
	rm -f {accelerated-domains,google,apple}.china.*.conf *.smartdns.conf {accelerated-domains,google,apple}.china.raw.txt dnscrypt-proxy-forwarding-rules.txt

.PHONY : clean-docker-cache
clean-docker-cache:
	docker builder prune

.PHONY : clean-docker-cache-all
clean-docker-cache-all:
	docker builder prune -a

.PHONY : default options help all build test compile clean
