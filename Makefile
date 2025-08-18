TAGS ?= all

.PHONY: init apply-all verbose

apply-all: init
	ansible-playbook --ask-become-pass --vault-password-file .vault-password --tags "$(TAGS)" playbook.yml

verbose: init
	ansible-playbook -vv --ask-become-pass --vault-password-file .vault-password playbook.yml

init: .vault-password group_vars/all/vault

.vault-password:
	$(error ".vault-password is missing. Create file containing vault password to continue")

group_vars/all/vault:
	$(error "Vault is missing (group_vars/all/vault). Create file containing vault entries continue")


REPO := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
install: $(REPO)installer/main.go
	go build -C "$(REPO)installer" -o "$(REPO)install"

