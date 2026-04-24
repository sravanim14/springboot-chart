{{/*
Expand the name of the chart.
*/}}
{{- define "springboot-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "springboot-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "springboot-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "springboot-chart.labels" -}}
helm.sh/chart: {{ include "springboot-chart.chart" . }}
release: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "springboot-chart.selectorLabels" . }}
{{ include "springboot-chart.customLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "springboot-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "springboot-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Custom labels
*/}}
{{- define "springboot-chart.customLabels" -}}
{{- range $key, $value := (.Values.deployment).labels -}}
{{ $key }} : {{ $value | quote }}
{{ end -}}
{{- range $key, $value := (.Values.job).labels -}}
{{ $key }} : {{ $value | quote }}
{{ end -}}
{{- end -}}

{{/*
Common annotations
*/}}
{{- define "springboot-chart.annotations" -}}
{{- range $key, $value := .Values.podAnnotations -}}
{{ $key }} : {{ $value | quote }}
{{ end -}}
{{- end -}}

{{/*
HashiCorp Vault annotations
*/}}
{{- define "springboot-chart.annotations.vault" -}}
{{- $defaultNamespace := printf "%s" .Values.envOverrides.env_type -}}
{{- $defaultVaultRole := printf "vault-role-%s" .Values.envOverrides.pillar -}}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-init-first: "true"
vault.hashicorp.com/role: {{ $defaultVaultRole | quote }}
vault.hashicorp.com/namespace: {{ $defaultNamespace | quote }}
{{- end -}}

{{/*
Common SecurityContext
*/}}
{{- define "springboot-chart.podSecurityContext" -}}
{{- $defaultRunAsUser := 1000 -}}
{{- $defaultRunAsGroup := 3000 -}}
{{- $defaultFsGroup := 2000 -}}
{{- $defaultRunAsNonRoot := "true" -}}
runAsUser: {{ default $defaultRunAsUser .Values.podSecurityContext.runAsUser }}
runAsGroup: {{ default $defaultRunAsGroup .Values.podSecurityContext.runAsGroup }}
fsGroup: {{ default $defaultFsGroup .Values.podSecurityContext.fsGroup }}
runAsNonRoot: {{ default $defaultRunAsNonRoot .Values.podSecurityContext.runAsNonRoot }}
{{- range $key, $value := .Values.podSecurityContext -}}
{{ $key }} : {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
Container SecurityContext
*/}}
{{- define "springboot-chart.containerSecurityContext" -}}
{{- $defaultRunAsUser := 1000 -}}
{{- $defaultRunAsGroup := 3000 -}}
{{- $defaultFsGroup := 2000 -}}
{{- $defaultRunAsNonRoot := "true" -}}
runAsUser: {{ default $defaultRunAsUser .Values.podSecurityContext.runAsUser }}
runAsGroup: {{ default $defaultRunAsGroup .Values.podSecurityContext.runAsGroup }}
fsGroup: {{ default $defaultFsGroup .Values.podSecurityContext.fsGroup }}
runAsNonRoot: {{ default $defaultRunAsNonRoot .Values.podSecurityContext.runAsNonRoot }}
{{- range $key, $value := .Values.containerSecurityContext -}}
{{ $key }} : {{ $value | quote }}
{{- end }}
{{- end -}}


{{/*
Pod ImagePullSecrets
*/}}
{{- define "springboot-chart.imagePullSecrets" -}}
{{- with .Values.deployment.image.imagePullSecrets }}
{{- toYaml . }}
{{- end }}
{{- end -}}
