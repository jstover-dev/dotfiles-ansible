TAGS ?= all

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

REPO := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

INSTALLER_SRC := $(call rwildcard,$(REPO)/installer,*.go) $(wildcard $(REPO)/installer/go.*)

.PHONY: apply-all
apply-all: init
	ansible-playbook --ask-become-pass --vault-password-file .vault-password --tags "$(TAGS)" playbook.yml

.PHONY: verbose
verbose: init
	ansible-playbook -vv --ask-become-pass --vault-password-file .vault-password playbook.yml

.PHONY: init
init: .vault-password group_vars/all/vault

.vault-password:
	$(error ".vault-password is missing. Create file containing vault password to continue")

group_vars/all/vault:
	$(error Vault is missing (group_vars/all/vault). Create file containing vault entries continue)

install: $(INSTALLER_SRC)
	go build -C "$(REPO)installer" -o "$(REPO)install"

