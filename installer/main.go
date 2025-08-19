package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path"
	"slices"
	"strings"

	"codeberg.org/jstover/dotfiles-ansible/installer/ui"
	tea "github.com/charmbracelet/bubbletea"
	"gopkg.in/yaml.v3"
)

const (
	ERROR_INVALID_ARGUMENTS = 1
	ERROR_MISSING_PLAYBOOK  = 2
	ERROR_INVALID_PLAYBOOK  = 3
	ERROR_STARTING_UI       = 4
	ERROR_CANCELLED         = 5
	ERROR_NO_ROLES_SELECTED = 6
	ERROR_RUNNING_ANSIBLE   = 7
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

func readPlaybookRoles(path string) ([]string, error) {
	roles := []string{}
	p := make([]struct{ Roles []string }, 1)
	buf, err := os.ReadFile(path)
	if err != nil {
		return roles, err
	}
	err = yaml.Unmarshal(buf, &p)
	if err != nil {
		return roles, fmt.Errorf("in file %q: %w", path, err)
	}
	roles = append(roles, p[0].Roles...)
	return roles, nil
}

func Usage() {
	usage := `
Usage: %s [OPTION]... [ROLE]...

Options:
    -i, --interactive \t       Start interactive mode
`
	fmt.Printf(usage, path.Base(os.Args[0]))
}

type programArgs struct {
	interactive bool
	selectRoles []string
}

func parseArgs() programArgs {
	a := programArgs{}
	if len(os.Args) == 1 {
		Usage()
		os.Exit(ERROR_INVALID_ARGUMENTS)
	}
	for _, arg := range os.Args[1:] {
		if arg == "-i" || arg == "--interactive" {
			a.interactive = true
		} else {
			a.selectRoles = append(a.selectRoles, arg)
		}
	}
	return a
}

func main() {

	args := parseArgs()

	playbookRoot, err := findPlaybookRoot()
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(ERROR_MISSING_PLAYBOOK)
	}
	playbookFile := path.Join(playbookRoot, "playbook.yml")

	roleNames, err := readPlaybookRoles(playbookFile)
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(ERROR_INVALID_PLAYBOOK)
	}

	enabledRoles := []string{}
	for _, role := range args.selectRoles {
		if slices.Contains(roleNames, role) {
			enabledRoles = append(enabledRoles, role)
		} else {
			fmt.Printf("Warning: %s is not a valid role name", role)
		}
	}

	if args.interactive {
		m := ui.NewModel(roleNames, args.selectRoles)
		tm, err := tea.NewProgram(m, tea.WithAltScreen()).Run()
		if err != nil {
			fmt.Printf("Error: %v", err)
			os.Exit(ERROR_STARTING_UI)
		}

		m = tm.(ui.Model)
		if m.Cancelled {
			fmt.Println("Installation cancelled,")
			os.Exit(ERROR_CANCELLED)
		}

		enabledRoles = m.EnabledRoles()
	}

	if len(enabledRoles) == 0 {
		fmt.Println("No roles selected.")
		os.Exit(ERROR_NO_ROLES_SELECTED)
	}

	err = runAnsible(playbookRoot, enabledRoles)
	if err != nil {
		fmt.Printf("Error: %v", err)
		os.Exit(ERROR_RUNNING_ANSIBLE)
	}

}
