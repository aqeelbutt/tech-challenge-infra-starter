resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "kube-system"
  values     = [
    <<EOF
controller:
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${var.acm_certificate_arn}
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"
EOF
  ]

  depends_on = [var.eks_cluster_ready]
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "default"
  values = [
    <<EOF
controller:
  adminUser: admin
  adminPassword: adminPassword
  installPlugins:
    - kubernetes:1.29.0
    - workflow-aggregator:2.6
    - git:4.6.0
    - configuration-as-code:1.51
  service:
    type: LoadBalancer
EOF
  ]

  depends_on = [var.eks_cluster_ready]
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }

  spec {
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/name" = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }

  depends_on = [var.eks_cluster_ready]
}

resource "kubernetes_service_account" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }

  depends_on = [var.eks_cluster_ready]
}

resource "kubernetes_cluster_role_binding" "jenkins" {
  metadata {
    name = "jenkins"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins.metadata[0].name
    namespace = kubernetes_service_account.jenkins.metadata[0].namespace
  }

  depends_on = [kubernetes_service_account.jenkins]
}

resource "kubernetes_job" "jenkins_config" {
  metadata {
    name      = "jenkins-config"
    namespace = "default"
  }

  spec {
    template {
      metadata {
        name = "jenkins-config"
      }

      spec {
        service_account_name = kubernetes_service_account.jenkins.metadata[0].name

        container {
          name  = "create-pipeline"
          image = "jenkins/jenkins:lts"
          command = [
            "sh", "-c",
            <<-EOF
              until curl -s http://localhost:8080/login > /dev/null; do echo "Waiting for Jenkins..."; sleep 5; done
              echo 'Creating Jenkins job...'
              curl -X POST -u admin:adminPassword --data-binary @/var/jenkins_home/workspace/TerraformPipeline/config.xml -H "Content-Type: application/xml" http://localhost:8080/createItem?name=TerraformPipeline
            EOF
          ]

          volume_mount {
            name      = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }

        restart_policy = "Never"

        volume {
          name = "jenkins-home"
          persistent_volume_claim {
            claim_name = "jenkins"
          }
        }
      }
    }

    backoff_limit = 4
  }

  depends_on = [kubernetes_service_account.jenkins]
}

resource "kubernetes_persistent_volume_claim" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }

  depends_on = [var.eks_cluster_ready]
}
