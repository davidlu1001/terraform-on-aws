SHELL=/usr/bin/env bash

.PHONY: clean plan apply test

# if make is typed with no further arguments, then show a list of available targets
default:
	@awk -F\: '/^[a-z_]+:/ && !/default/ {printf "- %-20s %s\n", $$1, $$2}' Makefile

clean:
	rm -rf .terraform
	rm -f current.plan
	rm -f *.tf.json

init:
	terraform init

get_modules:
	terraform get

plan: clean init get_modules
	terraform plan -out current.plan
	terraform show -no-color current.plan > txt.plan

apply: current.plan
	terraform apply -auto-approve current.plan

test:
	@terraform fmt -diff=true -write=false