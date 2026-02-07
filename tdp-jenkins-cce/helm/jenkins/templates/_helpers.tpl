{{- define "jenkins.name" -}}
jenkins
{{- end }}

{{- define "jenkins.fullname" -}}
{{ .Release.Name }}-jenkins
{{- end }}
