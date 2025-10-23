#############################
# PROJETO
#############################
resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account =  var.billing_account
  folder_id       = "folders/${var.folder_id}"
  deletion_policy = "DELETE"
}

#############################
# PERMISSÕES A NÍVEL DE PROJETO
#############################
resource "google_project_iam_member" "project_storage_viewer" {
  project = google_project.project.project_id
  member  = "group:engenharia.dados@abemcomum.org"
  role    = "roles/viewer"
  depends_on = [google_project_service.gcp_resource_manager_api]
}

#############################
# STORAGE BUCKET
#############################
resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  project       = google_project.project.project_id
}

#############################
# SERVICE ACCOUNT - SUBIDORES DE DADOS
#############################
resource "google_service_account" "service_account_subidores_dados" {
  account_id   = "${var.service_account_sub_dados}"
  display_name = "${var.service_account_sub_dados}"
  project      = google_project.project.project_id
}

# #############################
# # SERVICE ACCOUNT - ADMINISTRADORES DE DADOS
# #############################
resource "google_service_account" "service_account_administradores_dados" {
  account_id   = "${var.service_account_adm_dados}"
  display_name = "${var.service_account_adm_dados}"
  project      = google_project.project.project_id
}

# #############################
# # IAM NA SERVICE ACCOUNT - SUBIDORES DE DADOS
# #############################


resource "google_project_iam_member" "subidores_storage_editor" {
  project = google_project.project.project_id
  role    = "roles/storage.objectAdmin"
  member  = "group:engenharia.dados@abemcomum.org"
}

resource "google_project_iam_member" "subidores_bigquery_editor" {
  project = google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "group:engenharia.dados@abemcomum.org"
}

# #############################
# # IAM NA SERVICE ACCOUNT - ADMINISTRADORES DE DADOS
# #############################


resource "google_project_iam_member" "admin_dados_storage" {
  project = google_project.project.project_id
  role    = "roles/storage.admin"
  member  = "group:engenharia.dados@abemcomum.org"
}

resource "google_project_iam_member" "admin_dados_bigquery" {
  project = google_project.project.project_id
  role    = "roles/bigquery.admin"
  member  = "group:engenharia.dados@abemcomum.org"

}


##########################
# Google APIs Enablement
##########################
resource "google_project_service" "gcp_resource_manager_api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false
  depends_on = [google_project.project]

}

resource "google_project_service" "bigquery_api" {
  project = var.project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
  depends_on = [google_project.project,
                google_project_service.gcp_resource_manager_api,
                google_project_service.gcp_serviceusage_api]
}

resource "google_project_service" "gcp_serviceusage_api" {
  project = var.project_id
  service = "serviceusage.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
  depends_on = [google_project.project]
}
##########################
# BigQuery Conector:
# Referências: https://cloud.google.com/bigquery/docs/create-cloud-resource-connection?hl=pt-br#terraform
# Referências: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_connection#nested_cloud_resource
##########################
resource "google_bigquery_connection" "default" {
  connection_id = "my_cloud_resource_connection"
  project       = google_project.project.project_id
  location      = "US"
  cloud_resource {}
  depends_on = [google_project_service.gcp_resource_manager_api,
                google_project_service.bigquery_api]
}

resource "google_project_iam_member" "connectionPermissionGrant" {
  project = google_project.project.project_id
  role    = "roles/storage.objectAdmin"
  member  = "group:engenharia.dados@abemcomum.org"
}
