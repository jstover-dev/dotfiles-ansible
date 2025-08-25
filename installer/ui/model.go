package ui

import (
	"fmt"
	"slices"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type menuItem struct {
	name    string
	enabled bool
}

type ansibleRole menuItem
type ansibleHost menuItem

type menuCursor struct {
	pos int
	len int
}

func (c *menuCursor) increment() {
	if c.pos == c.len-1 {
		c.pos = 0
	} else {
		c.pos = c.pos + 1
	}
}

func (c *menuCursor) decrement() {
	if c.pos == 0 {
		c.pos = c.len - 1
	} else {
		c.pos = c.pos - 1
	}
}

type Model struct {
	help       help.Model
	keymap     keyMap
	roles      []ansibleRole
	roleCursor menuCursor
	hosts      []ansibleHost
	hostCursor menuCursor
	message    string
	Cancelled  bool
	all_value  bool
	page       string
}

func NewModel(roles []string, selectedRoles []string, hosts []string) Model {
	m := Model{
		help:       help.New(),
		keymap:     newKeyMap(),
		roles:      []ansibleRole{},
		roleCursor: menuCursor{pos: 0, len: len(roles)},
		hosts:      []ansibleHost{},
		hostCursor: menuCursor{pos: 0, len: len(hosts)},
		message:    "",
		page:       "hosts",
	}
	for _, name := range roles {
		role := ansibleRole{name: name, enabled: slices.Contains(selectedRoles, name)}
		m.roles = append(m.roles, role)
	}
	for _, name := range hosts {
		host := ansibleHost{name: name, enabled: name == "localhost"}
		m.hosts = append(m.hosts, host)
	}
	return m
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
			if m.page == "roles" {
				m.roleCursor.decrement()
			} else if m.page == "hosts" {
				m.hostCursor.decrement()
			}

		case key.Matches(msg, m.keymap.Down):
			if m.page == "roles" {
				m.roleCursor.increment()
			} else if m.page == "hosts" {
				m.hostCursor.increment()
			}

		case key.Matches(msg, m.keymap.All):
			m.all_value = !m.all_value
			for i := range m.roles {
				m.roles[i].enabled = m.all_value
			}

		case key.Matches(msg, m.keymap.Invert):
			if m.page == "roles" {
				for i, role := range m.roles {
					m.roles[i].enabled = !role.enabled
				}
			} else if m.page == "hosts" {
				for i, role := range m.hosts {
					m.hosts[i].enabled = !role.enabled
				}
			}

		case key.Matches(msg, m.keymap.Toggle):
			if m.page == "roles" {
				m.roles[m.roleCursor.pos].enabled = !m.roles[m.roleCursor.pos].enabled
			} else if m.page == "hosts" {
				m.hosts[m.hostCursor.pos].enabled = !m.hosts[m.hostCursor.pos].enabled
			}

		case key.Matches(msg, m.keymap.Next):
			switch m.page {
			case "hosts":
				if len(m.SelectedHosts()) == 0 {
					m.message = "At least one host must be selected."
				} else {
					m.message = ""
					m.page = "roles"
				}
				return m, nil
			case "roles":
				if len(m.SelectedRoles()) == 0 {
					m.message = "At least one role must be selected."
					return m, nil
				} else {
					m.message = ""
					m.page = ""
					return m, tea.Quit
				}
			default:
				return m, tea.Quit
			}

		case key.Matches(msg, m.keymap.Help):
			m.help.ShowAll = !m.help.ShowAll
		}

	}

	return m, nil
}

func (m Model) View() string {

	tick := lipgloss.NewStyle().Foreground(lipgloss.Color("2"))

	s := ""

	if m.page == "hosts" {
		s += "Select hosts:\n\n"
		if m.message != "" {
			s += m.message + "\n\n"
		}
		for i, host := range m.hosts {
			cursor := "  "
			if m.hostCursor.pos == i {
				cursor = " →"
			}
			checked := " "
			if host.enabled {
				checked = tick.Render("✓")
			}
			s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, host.name)
		}
	} else if m.page == "roles" {
		s += "Select roles to install:\n\n"
		if m.message != "" {
			s += m.message + "\n\n"
		}
		for i, role := range m.roles {
			cursor := "  "
			if m.roleCursor.pos == i {
				cursor = " →"
			}
			checked := " "
			if role.enabled {
				checked = tick.Render("✓")
			}
			s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, role.name)
		}
	} else {
		s += "Unknown Page: " + m.page
	}

	s += "\n" + m.help.View(m.keymap)
	return s
}

func (m Model) SelectedRoles() []string {
	enabledRoles := []string{}
	for _, role := range m.roles {
		if role.enabled {
			enabledRoles = append(enabledRoles, role.name)
		}
	}
	return enabledRoles
}

func (m Model) SelectedHosts() []string {
	selectedHosts := []string{}
	for _, host := range m.hosts {
		if host.enabled {
			selectedHosts = append(selectedHosts, host.name)
		}
	}
	return selectedHosts
}
