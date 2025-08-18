package ui

import "github.com/charmbracelet/bubbles/key"

type keyMap struct {
	Up     key.Binding
	Down   key.Binding
	All    key.Binding
	Invert key.Binding
	Toggle key.Binding
	Start  key.Binding
	Help   key.Binding
	Quit   key.Binding
}

func newKeyMap() keyMap {
	return keyMap{
		Up: key.NewBinding(
			key.WithKeys("up", "k"),
			key.WithHelp("(↑/k)", "previous"),
		),
		Down: key.NewBinding(
			key.WithKeys("down", "j"),
			key.WithHelp("(↓/j)", "next"),
		),
		All: key.NewBinding(
			key.WithKeys("a"),
			key.WithHelp("(a)", "select/deselect all"),
		),
		Invert: key.NewBinding(
			key.WithKeys("i"),
			key.WithHelp("(i)", "invert selection"),
		),
		Toggle: key.NewBinding(
			key.WithKeys(" "),
			key.WithHelp("(space)", "Toggle selection"),
		),
		Start: key.NewBinding(
			key.WithKeys("enter"),
			key.WithHelp("(enter)", "start installation"),
		),
		Help: key.NewBinding(
			key.WithKeys("?"),
			key.WithHelp("?", "toggle help"),
		),
		Quit: key.NewBinding(
			key.WithKeys("q", "ctrl-c"),
			key.WithHelp("(q)", "quit"),
		),
	}
}

func (k keyMap) ShortHelp() []key.Binding {
	return []key.Binding{k.Help, k.Quit}
}

func (k keyMap) FullHelp() [][]key.Binding {
	return [][]key.Binding{
		{k.Up, k.Down, k.All, k.Invert},
		{k.Toggle, k.Start}, // first column
		{k.Help, k.Quit},    // second column
	}
}
