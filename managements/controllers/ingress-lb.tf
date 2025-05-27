# resource "kubernetes_ingress_v1" "platform_ingress" {
#     metadata {
#         name = "platform-alb"
#         namespace = "platform"
#         annotations = {
#             "alb.ingress.kubernetes.io/backend-protocol" = "HTTPS"
#             "alb.ingress.kubernetes.io/healthcheck-path" = "/healthz"
#             "alb.ingress.kubernetes.io/healthcheck-port" = "8080"
#             "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "15"
#             "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = "5"
#             "alb.ingress.kubernetes.io/healthy-threshold-count" = "2"
#             "alb.ingress.kubernetes.io/unhealthy-threshold-count" = "2"
#             "alb.ingress.kubernetes.io/success-codes" = "200-399"
#             "alb.ingress.kubernetes.io/group.name" = "platform-alb"
#             "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#             "alb.ingress.kubernetes.io/target-type" = "ip"
#             "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
#                 {"HTTP" = 80},
#                 {"HTTPS" = 443}
#             ])
#             "alb.ingress.kubernetes.io/ssl-policy" = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#             "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:ap-northeast-2:182024812696:certificate/919b073a-43c4-4d1c-aee4-4e258a7a22fc"
#             "alb.ingress.kubernetes.io/ssl-redirect" = "443"
#         }
#     }

#     spec {
#         ingress_class_name = "alb"
        
#         rule {
#             host = "argo.leedonggyu.com"
#             http {
#                 path {
#                     path = "/"
#                     path_type = "Prefix"
#                     backend {
#                         service {
#                             name = "argocd-server"
#                             port {
#                                 number = 443
#                             }
#                         }
#                     }
#                 }
#             }
#         }
#     }
# }
