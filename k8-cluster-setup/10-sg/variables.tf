variable "project" {
    default = "Zeitview"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        project = "eitview"
        environment = "dev"
        terraform = "true"
    }
}




