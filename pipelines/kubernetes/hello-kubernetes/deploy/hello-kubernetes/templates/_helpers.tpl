{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "hello-kubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hello-kubernetes.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hello-kubernetes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hello-kubernetes.labels" -}}
app.kubernetes.io/name: {{ include "hello-kubernetes.name" . }}
helm.sh/chart: {{ include "hello-kubernetes.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hello-kubernetes.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-kubernetes.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Rollout stable service name
*/}}
{{- define "hello-kubernetes.serviceName" -}}
{{- if and .Values.rollouts.enabled .Values.rollouts.blueGreen.activeService -}}
{{- .Values.rollouts.blueGreen.activeService -}}
{{- else -}}
{{ include "hello-kubernetes.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Rollout secondary service name.
BlueGreen -> preview service
Canary    -> canary service
*/}}
{{- define "hello-kubernetes.rolloutServiceName" -}}
{{- if not .Values.rollouts.enabled -}}
{{- include "hello-kubernetes.fullname" . -}}
{{- else if eq .Values.rollouts.strategy "blueGreen" -}}
{{- if .Values.rollouts.blueGreen.previewService -}}
{{- .Values.rollouts.blueGreen.previewService -}}
{{- else -}}
{{- printf "%s-preview" (include "hello-kubernetes.fullname" .) -}}
{{- end -}}
{{- else if eq .Values.rollouts.strategy "canary" -}}
{{- if .Values.rollouts.canary.canaryService -}}
{{- .Values.rollouts.canary.canaryService -}}
{{- else -}}
{{- printf "%s-canary" (include "hello-kubernetes.fullname" .) -}}
{{- end -}}
{{- else -}}
{{- fail "Unsupported rollouts.strategy; expected blueGreen or canary" -}}
{{- end -}}
{{- end -}}
