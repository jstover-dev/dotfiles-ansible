install: .vault-password group_vars/all/vault
	ansible-playbook --ask-become-pass --vault-password-file .vault-password playbook.yml

.vault-password:
	$(error ".vault-password is missing. Create file containing vault password to continue")

group_vars/all/vault:
	$(error "Vault is missing (group_vars/all/vault). Create file containing vault entries continue")

