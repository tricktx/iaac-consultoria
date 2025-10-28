terraform {
    required_providers {
    googleworkspace = {
        source  = "hashicorp/googleworkspace"
        version = "~> 0.7"
    }
    }
}

provider "googleworkspace" {
    credentials = file("/home/tricktx/iaac-consultoria/service-account.json")
    customer_id = ""  #ID da organização Google Workspace
}