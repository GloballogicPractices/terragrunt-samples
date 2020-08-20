SHELL := /bin/bash

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: init plan apply test  ## Runs plan, apply and test

destroy:  ## Terraform Destroy

init:  ## Terraform Init

plan:  ## Terraform Plan

apply:  ## Terraform Apply

test:  ## Run AWSPEC unit tests
	@echo "Testing"
	bash -c "go test -v ./test -timeout 400s"

.DEFAULT_GOAL := all
.PHONY: all destroy plan apply test
