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
    "pubsub.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "cloudfunctions.googleapis.com"
  ]
}
variable "cloudfunctions_source_code_path" {
  description = "path for function src and lib"
  type        = string
  default     = "./function-build/"
}
variable "wechat_webhook" {
  description = "alert_channel_wechat"
  type        = string
  default     = ""
}
variable "dingtalk_webhook" {
  description = "alert_channel_dingding"
  type        = string
  default     = ""
}
