variable "metric_attr" {
  default = {
    "name"       = "metrics-server"
    "chart"      = "metrics-server"
    "namespace"  = "kube-system"
    "repository" = "https://kubernetes-sigs.github.io/metrics-server/"
  }
}

resource "helm_release" "metrics_server" {
  name       = lookup(var.metric_attr, "name")
  repository = lookup(var.metric_attr, "repository")
  chart      = lookup(var.metric_attr, "chart")
  namespace  = lookup(var.metric_attr, "namespace")

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls,--kubelet-preferred-address-types=InternalIP}"
  }

  depends_on = [module.eks]
} 