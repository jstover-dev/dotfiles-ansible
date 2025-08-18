# dotfiles

Personal dotfiles using Ansible

## Usage

### Apply All

A makefile target exists which applies all configurations

```sh
make apply-all
```

Alternatively, run Ansible manually:

```sh
ansible-playbook --ask-become-pass \
    --vault-password-file .vault-password \
    playbook.yml
```

### Select targets

Each target is defined as an Ansible role,
and can be selected using a tag of the same name.

_e.g._ to apply the `git` and `zsh` configuration:

```sh
ansible-playbook --ask-become-pass \
    --vault-password-file .vault-password \
    --tage git,zsh
    playbook.yml
```

For an interactie selection, run the included `install` application

```sh
$ ./install
Select roles to install:

 → [ ] core
   [ ] profile
   [ ] fonts
   [x] zsh
   [ ] asdf
   [ ] python
   [ ] neovim
   [ ] aria2
   [ ] direnv
   [ ] docker
   [ ] mc
   [ ] pacman
   [ ] tmux
   [ ] xmonad
   [ ] starship
   [ ] konsole
   [x] git
   [ ] mercurial
   [ ] mutt
   [ ] kitty
? toggle help • (q) quit
```

### Vault

Variables are stored in `group_vars/all/vault`.
Encrypted values will be decrypted using the password stored in `.vault-password`
