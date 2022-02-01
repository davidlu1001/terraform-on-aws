SHELL=/usr/bin/env bash
PLAN_OPTIONS ?=
APPLY_OPTIONS ?=
EXCLUDE ?=
INCLUDE ?=

define PLAN_OPTIONS_EXCLUDE
	$(shell terraform show -no-color current.plan | sed -n '/Terraform will perform the following actions/,$$p' | perl -nle 'if (/\s# (.*?)\s/) {print $$1}' | grep -E -v '$(1)' | sed -e 's/^/-target="/g' -e 's/$$/"/g' | xargs)
endef

define PLAN_OPTIONS_INCLUDE
	$(shell terraform show -no-color current.plan | sed -n '/Terraform will perform the following actions/,$$p' | perl -nle 'if (/\s# (.*?)\s/) {print $$1}' | grep -E '$(1)' | sed -e 's/^/-target="/g' -e 's/$$/"/g' | xargs)
endef

.PHONY: clean plan apply test

# if make is typed with no further arguments, then show a list of available targets
default:
	@awk -F\: '/^[a-z_]+:/ && !/default/ {printf "- %-20s %s\n", $$1, $$2}' Makefile

help:
	@echo ""
	@echo " Usage: "
	@echo " Run make plan to show pending changes then pick the resource you want to target"
	@echo " [INCLUDE|EXCLUDE] support POSIX Extended Regular Expressions (ERE)"
	@echo ""
	@echo " e.g."
	@echo " PLAN_OPTIONS=\"-target=\"aws_iam_policy.ec2-read\"\" make plan"
	@echo " APPLY_OPTIONS=\"-target=\"aws_iam_policy.ec2-read\"\" make apply"
	@echo " make plan_exclude EXCLUDE='aws_eip'"
	@echo " make plan_include INCLUDE='ecs|null|route|nat'"
	@echo ""
	@echo " To see a list of available targets, run make without arguments"

clean:
	rm -rf .terraform
	rm -f current.plan
	rm -f *.tf.json

init:
	terraform init

get_modules:
	terraform get

check: clean get_modules
	@cd "$$(git rev-parse --show-toplevel)" || exit 1
	docker run -v "$$(pwd)":/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:latest run -a

plan: clean init get_modules
	terraform plan -out current.plan ${PLAN_OPTIONS}
	terraform show -no-color current.plan > txt.plan

plan_exclude:
	terraform plan -out current.plan $(strip $(call PLAN_OPTIONS_EXCLUDE,$(EXCLUDE)))

plan_include:
	terraform plan -out current.plan $(strip $(call PLAN_OPTIONS_INCLUDE,$(INCLUDE)))

apply: current.plan
	terraform apply -auto-approve ${APPLY_OPTIONS} current.plan

test:
	@terraform fmt -diff=true -write=false

destroy_plan:
	terraform plan -destroy -out destroy.plan

destroy_apply:
	terraform apply -destroy destroy.plan

doc:
	@cd "$$(git rev-parse --show-toplevel)" && for i in common/modules/* {test,prod}/ap-southeast-2; do terraform-docs markdown --output-file README.md $$i; done

