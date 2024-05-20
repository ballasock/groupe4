# Fichier : main.tf

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Déclaration du provider Kubernetes
provider "kubernetes" {
  config_path = "/home/rootkit/.kube/config"
}


# Récupération du contenu YAML pour le déploiement PHP
resource  "kubernetes_manifest" "apache-deployment" {
  manifest = yamldecode(file("../app-deployment.yml"))  
}

# Récupération du contenu YAML pour le déploiement MySQL
resource "kubernetes_manifest" "db-base" {
  manifest = yamldecode(file("../db-deployment.yml")) 
}

resource "kubernetes_manifest" "apache-service" {
  manifest = yamldecode(file("../app-service.yml")) 
}

resource "kubernetes_manifest" "db" {
  manifest = yamldecode(file("../db-service.yml")) 
}