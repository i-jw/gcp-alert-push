provider "google" {
  project = var.project_id
  region  = var.region
}
resource "random_id" "tf_subfix" {
  byte_length = 4
}
# Enable related service
resource "google_project_service" "gcp_services" {
  for_each                   = toset(var.gcp_service_list)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

data "google_compute_default_service_account" "default" {
  depends_on = [google_project_service.gcp_services]
}

data "google_project" "project" {
}

data "archive_file" "function" {
  type             = "zip"
  source_dir       = var.cloudfunctions_source_code_path
  output_file_mode = "0666"
  output_path      = "./cloud_function.zip"
}


# pubsub topic
resource "google_pubsub_topic" "alert" {
  name = "gcp-alert-push-topic-${random_id.tf_subfix.hex}"
}

# grant pubsub publisher permission
resource "google_pubsub_topic_iam_binding" "binding" {
  project = var.project_id
  topic   = google_pubsub_topic.alert.name
  role    = "roles/pubsub.publisher"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-monitoring-notification.iam.gserviceaccount.com",
  ]
}

resource "google_monitoring_notification_channel" "pubsub_alert_channel" {
  display_name = "Pubsub Push Notification Channel"
  type         = "pubsub"
  labels = {
    topic = google_pubsub_topic.alert.id
  }
  force_delete = true
}

# function_source_gcs_bucket
resource "google_storage_bucket" "bucket" {
  name                        = "cloud-function-source-${random_id.tf_subfix.hex}"
  project                     = var.project_id
  location                    = var.region
  force_destroy               = true
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
  depends_on                  = [google_project_service.gcp_services]
}
# function_source_zip
resource "google_storage_bucket_object" "archive" {
  name   = "cloud_function.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./cloud_function.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "function-${random_id.tf_subfix.hex}"
  location    = var.region
  description = "a new function"

  build_config {
    runtime     = "python310"
    entry_point = "app"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    min_instance_count    = 1
    available_memory      = "129Mi"
    timeout_seconds       = 30
    service_account_email = data.google_compute_default_service_account.default.email
    environment_variables = {
      WECHAT = var.wechat_webhook
      DINGTALK   = var.dingtalk_webhook
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.alert.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
