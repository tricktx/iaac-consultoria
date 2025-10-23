########
# Ativando a API https://console.cloud.google.com/apis/library/cloudresourcemanager.googleapis.com?project=bem-comum-prod:
# Derivada do erro: Error 403: Cloud Resource Manager API has not been used in project bem-comum-prod before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=bem-comum-prod then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry
#######

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


############################
# NOTIFICAÇÃO DE BUDGET
############################
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Notificação de custos GCP"
  type         = "email"

  labels = {
    email_address = "Patrick.teixeira@basedosdados.org"
  }

  depends_on = [
                google_project_service.gcp_storage_api,
                google_project_service.billing_budget_api,
                google_project_service.billing_monitoring_api,
                google_project_service.billing_iam_api,]
}
## EM CASO DE BUDGETS, É PRECISO ATIVAR A API DE BUDGETS: https://console.cloud.google.com/apis/library/billingbudgets.googleapis.com
############################
# BUDGET BIGQUERY
############################
resource "google_billing_budget" "budget_bigquery" {
  billing_account = var.billing_account
  display_name    = "Budget BigQuery"

  budget_filter {
    projects = ["projects/${var.project_id}"]
    services = [local.services.bigquery]
  }

  amount {
    specified_amount {
      currency_code = "BRL"
      units         = "10"
    }
  }

  threshold_rules { # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget#nested_threshold_rules
      threshold_percent = local.thresholds.threshold
    }


  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.email_channel.id,
    ]
    disable_default_iam_recipients = true
  }

  depends_on = [
                google_project_service.gcp_storage_api,
                google_project_service.billing_budget_api,
                google_project_service.billing_monitoring_api,
                google_project_service.billing_iam_api,]
}

#############################
# BUDGET STORAGE
#############################
resource "google_billing_budget" "budget_storage" {
  billing_account = var.billing_account
  display_name    = "Budget Storage"

  budget_filter {
    projects = ["projects/${var.project_id}"]
    services = [local.services.storage]
  }

  amount {
    specified_amount {
      currency_code = "BRL"
      units         = "10"
    }
  }

  threshold_rules { # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget#nested_threshold_rules
      threshold_percent = local.thresholds.threshold
    }

  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.email_channel.id,
    ]
    disable_default_iam_recipients = true
  }

  depends_on = [google_project_service.gcp_storage_api,
                google_project_service.billing_budget_api,
                google_project_service.billing_monitoring_api,
                google_project_service.billing_iam_api,]
}
