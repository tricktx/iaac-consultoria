resource "google_project_service" "gcp_admin_api" {
  project = "datalakehouse-475719"
  service = "admin.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy         = false

}

resource "googleworkspace_group" "equipe_dados" {
  email       = "equipe_dados@abemcomum.org"
  name        = "equipe_dados"
  description = "Equipe Dados Group"
  depends_on = [google_project_service.gcp_admin_api]
}

resource "googleworkspace_group_member" "patrick" {
  group_id = googleworkspace_group.equipe_dados.id
  email    = "patrick.teixeira@basedosdados.org"
  role     = "MEMBER"
}