package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path"
	"strings"

	"codeberg.org/jstover/dotfiles-ansible/installer/ui"
	tea "github.com/charmbracelet/bubbletea"
)

func runAnsible(dir string, enabledRoles []string) error {
	argv := []string{
		"--ask-become-pass",
		"--vault-password-file", ".vault-password",
		"--tags", strings.Join(enabledRoles, ","),
		"playbook.yml",
	}
	cmd := exec.Command("ansible-playbook", argv...)
	cmd.Dir = dir
	stdin, err := cmd.StdinPipe()
	if err != nil {
		return fmt.Errorf("unable to get StdinPipe")
	}
	defer stdin.Close()
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	fmt.Printf("+ %s %s\n", "ansible-playbook", strings.Join(argv, " "))
	if err = cmd.Start(); err != nil {
		return fmt.Errorf("unable to start process: %w", err)
	}
	cmd.Wait()
	return nil
}

func findPlaybookRoot() (string, error) {
	staticPaths := []string{
		"playbook.yml",
		"../playbook.yml",
	}
	exe, err := os.Executable()
	if err == nil {
		staticPaths = append(staticPaths, path.Join(path.Dir(exe), "playbook.yml"))
	}
	for _, f := range staticPaths {
		if _, err := os.Stat(f); err == nil {
			return path.Dir(f), nil
		}
	}
	return "", errors.New("playbook.yml not found")
}

func main() {

	playbookRoot, err := findPlaybookRoot()
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}

	playbookFile := path.Join(playbookRoot, "playbook.yml")

	m, err := ui.NewModel(playbookFile)
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}

	tm, err := tea.NewProgram(m, tea.WithAltScreen()).Run()
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}

	m = tm.(ui.Model)
	if m.Cancelled {
		fmt.Println("Installation cancelled,")
		os.Exit(0)
	}

	enabledRoles := m.EnabledRoles()
	if len(enabledRoles) == 0 {
		fmt.Println("No roles selected.")
		os.Exit(0)
	}

	err = runAnsible(playbookRoot, enabledRoles)
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(1)
	}

}
