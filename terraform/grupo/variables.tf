#############################
# VARIABLES
#############################

variable "location" {
    description = "Localização do bucket"
    type        = string
    default     = "us-central1"
}

variable "zone" {
    description     = "A região dos recursos do Google Cloud"
    type            = string
    default         = "us-central1-a"
    }
