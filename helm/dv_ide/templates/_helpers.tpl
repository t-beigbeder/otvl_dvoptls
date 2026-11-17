{{/*
Set the ingress hostname
*/}}
{{- define "otvl-dv-ingress-hostname" -}}
{{- if .Values.ingress.host -}}
{{- print .Values.ingress.host -}}
{{- else -}}
{{- printf "%s.example.com" .Release.Name }}
{{- end -}}
{{- end }}
{{/*
Set the ingress alternate hostname
*/}}
{{- define "otvl-dv-ingress-alt-hostname" -}}
{{- if .Values.ingress.alt_host -}}
{{- print .Values.ingress.alt_host -}}
{{- else -}}
{{- printf "alt-%s.example.com" .Release.Name }}
{{- end -}}
{{- end }}
