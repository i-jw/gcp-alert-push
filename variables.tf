variable "project_id" {
  description = "Project ID of the cloud resource."
  type        = string
}

variable "region" {
  description = "Region to set for gcp resource deploy."
  type        = string
}
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com"
  ]
}
variable "cloudfunctions_source_code_path" {
  description = "path for function src and lib"
  type        = string
  default     = "./function-build/"
}
variable "alert_channel_webhook_url" {
  description = "alert_channel_webhook_url"
  type        = string
}
