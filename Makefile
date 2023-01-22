# Usage:
# make        # compile all binary
# make clean  # remove ALL binaries and objects

AUTHOR                     ?= issenn

china-list                 := china-list

default: all
	@echo 'Run `make options` for a list of all options'

options: help
	@echo
	@echo 'Options:'

help:
	@echo 'make:                 Test and compile.'
	@echo 'make clean:           Remove the compiled files'

all: $(china-list) build

.PHONY: $(china-list)
$(china-list):
	$(MAKE) --directory=$@


.PHONY : debug
debug:

build:
	cp -f $(china-list)/dnscrypt-proxy-forwarding-rules.txt config/dnscrypt-proxy/rules/forwarding-rules.txt
	cp -f $(china-list)/*.raw.txt config/coredns/rules/

test:

compile:

clean:
	@echo "Cleaning up..."

.PHONY : default options help all build test compile clean
