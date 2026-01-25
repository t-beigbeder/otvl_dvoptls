{{/*
Set the ingress hostname
*/}}
{{- define "awf-ingress-hostname" -}}
{{- if .Values.ingress.host -}}
{{- print .Values.ingress.host -}}
{{- else -}}
{{- printf "%s.example.com" .Release.Name }}
{{- end -}}
{{- end }}
