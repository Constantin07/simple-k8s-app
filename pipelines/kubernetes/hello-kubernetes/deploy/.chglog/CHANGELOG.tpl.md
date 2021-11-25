{{ range .Versions -}}
{{ .Tag.Name }}:
{{ range .Commits -}}
{{ indent .Hash.Short 2 }}: {{ .Subject }}
{{ end }}
{{ end -}}
