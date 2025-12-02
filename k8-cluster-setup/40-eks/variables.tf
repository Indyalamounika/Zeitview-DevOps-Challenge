variable "project" {
    default = "Zeitview"

}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        project = "Zeitview"
        environment = "dev"
        terraform = "true"
    }
}