{{/*
Pod Volumes Helper
Supports: emptyDir, configMap, secret, PVC
*/}}
{{- define "springboot-chart.volumes" -}}
{{- range .Values.volumes }}
  {{- /* Validate name */}}
  {{- if not .name }}
    {{- fail "ERROR: volume.name is required" }}
  {{- end }}
  {{- /* Validate mountPath */}}
  {{- if not .mountPath }}
    {{- fail (printf "ERROR: mountPath is required for volume '%s'" .name) }}
  {{- end }}
- name: {{ .name }}
    {{- /* Handle emptyDir with defaults */}}
    {{- if .emptyDir }}
  emptyDir:
    medium: {{ default "Memory" .emptyDir.medium | quote }}
    sizeLimit: {{ default "500Mi" .emptyDir.sizeLimit | quote }}
    {{- /* Handle configMap */}}
    {{- else if .configMap }}
  configMap:
    name: {{ .configMap.name }}
    {{- /* Handle secret */}}
    {{- else if .secret }}
  secret:
    secretName: {{ .secret.secretName }}
    {{- /* Handle PVC */}}
    {{- else if .persistentVolumeClaim }}
  persistentVolumeClaim:
    claimName: {{ .persistentVolumeClaim.claimName }}
    {{- else }}
      {{- fail (printf "ERROR: Unsupported volume type for '%s'. Must be emptyDir, configMap, secret, or persistentVolumeClaim." .name) }}
    {{- end }}
{{- end }}
{{- end -}}

{{/*
Pod Volume Mounts Helper
Supports: emptyDir, configMap, secret, PVC
*/}}
{{- define "springboot-chart.volumeMounts" -}}
{{- range .Values.volumes }}
  {{- /* Validate name */}}
  {{- if not .name }}
    {{- fail "ERROR: volume.name is required" }}
  {{- end }}
  {{- /* Validate mountPath */}}
  {{- if not .mountPath }}
    {{- fail (printf "ERROR: mountPath is required for volume '%s'" .name) }}
  {{- end }}
- name: {{ .name }}
  mountPath: {{ .mountPath }}
    {{- if .subPath }}
  subPath: {{ .subPath | quote }}
    {{- end }}
    {{- if .readOnly }}
  readOnly: true
    {{- end }}
{{- end }}
{{- end -}}