provider "kubernetes" {
  host                   = var.kubernetes_cluster_host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.access_token
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_cluster_host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    token                  = var.access_token
  }
}

# Create the namespace where the Helm release will be installed
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

# Load values from template file (optional but useful)
data "template_file" "values" {
  template = file("${path.module}/templates/helm_values.tpl")
}

# Install the Helm chart
resource "helm_release" "my_helm_release" {
  name       = var.release_name
  repository = var.helm_repo
  chart      = var.helmchart_name
  version    = var.helmchart_version
  namespace  = kubernetes_namespace.namespace.metadata[0].name
  values     = [data.template_file.values.rendered]

  depends_on = [kubernetes_namespace.namespace]
}
