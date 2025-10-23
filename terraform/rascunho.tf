########
# Ativando a API https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com?project=bem-comum-prod:
# Derivada do erro: Error 403: Cloud Resource Manager API has not been used in project bem-comum-prod before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=bem-comum-prod then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry
#######
resource "google_project_service" "gcp_resource_manager_api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "gcp_bigquery_api" {
  project = var.project_id
  service = "bigquery.googleapis.com"
  disable_dependent_services = true  # necessário se quiser forçar desativar dependentes
  disable_on_destroy = false        # Evita erros no destroy
}

resource "google_project_service" "gcp_storage_api" {
  project = var.project_id
  service = "storage.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}

resource "google_project_service" "billing_budget_api" {
  project = var.project_id
  service = "billingbudgets.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}

resource "google_project_service" "billing_monitoring_api" {
  project = var.project_id
  service = "monitoring.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}

resource "google_project_service" "billing_iam_api" {
  project = var.project_id
  service = "iam.googleapis.com"
  disable_on_destroy = false
}


resource "google_cloud_identity_group" "grupo_engenheiros" {
  display_name         = "grupo_engenheiros"

  parent = "customers/498211284038" # ID do cliente do Cloud Identity / Google Workspace

  group_key {
            id = "grupo_engenheiros@basedosdados.org"
  }

  labels = {
      "cloudidentity.googleapis.com/groups.security" = ""
  }
}

resource "google_cloud_identity_group_membership" "membros_engenheiros" {

  for_each = toset([
    "patrick.teixeira@basedosdados.org",
    "gabriel.pisa@basedosdados.org",
    "luiza.vilela@basedosdados.org",
    "artemisia.weyl@basedosdados.org",
    "laura.amaral@basedosdados.org"]
  )


  group = "groups/${google_cloud_identity_group.grupo_engenheiros.name}"

  preferred_member_key{
    id = each.value
  }

  roles {
    name = "MEMBER"
  }
}
