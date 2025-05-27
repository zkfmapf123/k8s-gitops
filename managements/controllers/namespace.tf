variable "namespace" {
  default = {
    "service" :  {}
    "platform" : {}
  }
}

resource "kubernetes_namespace" "namespace" {
    for_each = var.namespace

    metadata {
        name = each.key
    }
}

