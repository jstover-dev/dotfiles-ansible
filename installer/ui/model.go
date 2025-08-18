package ui

import (
	"fmt"
	"os"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"gopkg.in/yaml.v3"
)

type ansibleRole struct {
	name    string
	enabled bool
}

type Model struct {
	help      help.Model
	keymap    keyMap
	roles     []ansibleRole
	cursor    int
	Cancelled bool
	all_value bool
}

func readPlaybookRoles(playbookFile string) ([]ansibleRole, error) {
	roles := []ansibleRole{}
	p := make([]struct{ Roles []string }, 1)
	buf, err := os.ReadFile(playbookFile)
	if err != nil {
		return roles, err
	}
	err = yaml.Unmarshal(buf, &p)
	if err != nil {
		return roles, fmt.Errorf("in file %q: %w", playbookFile, err)
	}
	for _, name := range p[0].Roles {
		roles = append(roles, ansibleRole{name: name})
	}
	return roles, nil
}

func NewModel(playbookFile string) (Model, error) {
	m := Model{
		help:   help.New(),
		keymap: newKeyMap(),
		roles:  []ansibleRole{},
		cursor: 0,
	}
	roles, err := readPlaybookRoles(playbookFile)
	if err != nil {
		return m, err
	}
	m.roles = roles
	return m, nil
}

func (m Model) Init() tea.Cmd {
	return nil
}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch {

		case key.Matches(msg, m.keymap.Quit):
			m.Cancelled = true
			return m, tea.Quit

		case key.Matches(msg, m.keymap.Up):
			m.cursor = max(m.cursor-1, 0)

		case key.Matches(msg, m.keymap.Down):
			m.cursor = min(len(m.roles)-1, m.cursor+1)

		case key.Matches(msg, m.keymap.All):
			m.all_value = !m.all_value
			for i := range m.roles {
				m.roles[i].enabled = m.all_value
			}

		case key.Matches(msg, m.keymap.Invert):
			for i, role := range m.roles {
				m.roles[i].enabled = !role.enabled
			}

		case key.Matches(msg, m.keymap.Toggle):
			m.roles[m.cursor].enabled = !m.roles[m.cursor].enabled

		case key.Matches(msg, m.keymap.Start):
			return m, tea.Quit

		case key.Matches(msg, m.keymap.Help):
			m.help.ShowAll = !m.help.ShowAll
		}

	}

	return m, nil
}

func (m Model) View() string {

	tick := lipgloss.NewStyle().Foreground(lipgloss.Color("2"))

	s := "Select roles to install:\n\n"
	for i, role := range m.roles {
		cursor := "  "
		if m.cursor == i {
			cursor = " →"
		}
		checked := " "
		if role.enabled {
			checked = tick.Render("✓")
		}
		s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, role.name)
	}
	s += m.help.View(m.keymap)
	return s
}

func (m Model) EnabledRoles() []string {
	enabledRoles := []string{}
	for _, role := range m.roles {
		if role.enabled {
			enabledRoles = append(enabledRoles, role.name)
		}
	}
	return enabledRoles
}
