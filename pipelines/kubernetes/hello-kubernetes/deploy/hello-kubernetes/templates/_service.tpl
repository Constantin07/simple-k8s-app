{{- define "hello-kubernetes.service" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ default (include "hello-kubernetes.fullname" .) .serviceName }}
  labels: {{- include "hello-kubernetes.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - protocol: {{ .Values.service.protocol }}
      port: {{ .Values.service.port }}
    {{- if .Values.proxy.enabled }}
      targetPort: {{ .Values.proxy.port }}
    {{- else }}
      targetPort: {{ .Values.container.port }}
    {{- end }}
  selector:
    {{- include "hello-kubernetes.selectorLabels" . | nindent 4 }}
{{- end }}
