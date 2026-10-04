# hello-kubernetes

![Version: 1.0.46](https://img.shields.io/badge/Version-1.0.46-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for a simple Hello Kubernetes application

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| consulTemplate.enabled | bool | `false` |  |
| consulTemplate.image.pullPolicy | string | `"Always"` |  |
| consulTemplate.image.repository | string | `"constantin07/consul-template"` |  |
| consulTemplate.image.tag | string | `"0.37.6"` |  |
| consulTemplate.resources.limits.cpu | string | `"60m"` |  |
| consulTemplate.resources.limits.memory | string | `"96Mi"` |  |
| consulTemplate.resources.requests.cpu | string | `"20m"` |  |
| consulTemplate.resources.requests.memory | string | `"32Mi"` |  |
| container.port | int | `8080` |  |
| deployment | object | `{"enabled":true,"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":1},"type":"RollingUpdate"}}` | Whether to enable K8s deployment |
| env | object | `{}` |  |
| hpa.enabled | bool | `false` |  |
| hpa.maxReplicas | int | `4` |  |
| httpRoute | object | `{"enabled":false}` | Whether to enable Gateway API HTTPRoute |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"constantin07/hello-kubernetes"` |  |
| image.tag | string | `"0.0.1"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.host | string | `"chart-example.local"` |  |
| ingress.path | string | `"/"` |  |
| proxy.enabled | bool | `false` |  |
| proxy.image.pullPolicy | string | `"Always"` |  |
| proxy.image.repository | string | `"constantin07/docker-nginx-proxy"` |  |
| proxy.image.tag | string | `"0.0.1"` |  |
| proxy.port | int | `8443` |  |
| proxy.resources.limits.cpu | string | `"100m"` |  |
| proxy.resources.limits.memory | string | `"64Mi"` |  |
| proxy.resources.requests.cpu | string | `"20m"` |  |
| proxy.resources.requests.memory | string | `"32Mi"` |  |
| replicaCount | int | `1` | Number of pods to deploy |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"50m"` |  |
| resources.requests.memory | string | `"100Mi"` |  |
| rollout | object | `{"enabled":false,"strategy":{"blueGreen":{"autoPromotionEnabled":true,"autoPromotionSeconds":30,"previewReplicaCount":1,"scaleDownDelaySeconds":30}}}` | Whether to enable Argo Rollout |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.runAsGroup | int | `10001` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `10001` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| service.port | int | `8080` |  |
| service.protocol | string | `"TCP"` |  |
| service.type | string | `"ClusterIP"` |  |
| vaultAgent.enabled | bool | `false` |  |
| vaultAgent.env | object | `{}` |  |
| vaultAgent.image.pullPolicy | string | `"Always"` |  |
| vaultAgent.image.repository | string | `"constantin07/vault-agent"` |  |
| vaultAgent.image.tag | string | `"1.16.2"` |  |
| vaultAgent.resources.limits.cpu | string | `"70m"` |  |
| vaultAgent.resources.limits.memory | string | `"32Mi"` |  |
| vaultAgent.resources.requests.cpu | string | `"20m"` |  |
| vaultAgent.resources.requests.memory | string | `"20Mi"` |  |
| vaultAgent.role | string | `""` |  |
