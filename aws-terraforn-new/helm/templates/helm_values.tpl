service:
  type: NodePort

replicaCount: 2

resources:
  limits:
    cpu: 100m
    memory: 128Mi
