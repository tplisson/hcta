provider "google" {
  credentials = file("<YOUR_GCP_CREDENTIALS_FILE>")
  project     = "<YOUR_GCP_PROJECT_ID>"
  region      = "<YOUR_GCP_REGION>"
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-instance"
  machine_type = "n1-standard-1"
  zone         = "<YOUR_GCP_ZONE>"

  dynamic "network_interface" {
    for_each = var.networks

    content {
      network = network_interface.value["network"]
    }
  }
}