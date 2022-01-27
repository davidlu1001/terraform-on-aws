SHELL=/usr/bin/env bash
PLAN_OPTIONS ?=
APPLY_OPTIONS ?=

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

check: clean get_modules
	cd "$$(git rev-parse --show-toplevel)" || exit 1
	docker run -v "$$(pwd)":/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:latest run -a

plan: clean init get_modules
	terraform plan -out current.plan ${PLAN_OPTIONS}
	terraform show -no-color current.plan > txt.plan

apply: current.plan
	terraform apply -auto-approve ${APPLY_OPTIONS} current.plan

test:
	@terraform fmt -diff=true -write=false

destroy_plan:
	terraform plan -destroy -out destroy.plan

destroy_apply:
	terraform apply -destroy destroy.plan