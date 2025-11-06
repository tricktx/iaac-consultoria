terraform {
    required_providers {
        google = {
                source  = "hashicorp/google" # 	Especifica o endereço de origem global do provedor.
                version = "6.36.1" # 	Especifica a versão do provedor que essa configuração deve usar.
        }
    }
}

provider "google" {
    project                 = var.project_id
    region                  = var.location
    zone                    = var.zone
    billing_project         = var.project_id
    user_project_override   = true
}
