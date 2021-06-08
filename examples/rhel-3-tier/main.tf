module "terraform-google-rhel-N-tier" {
  source       = ".../modules/terraform-google-windows-N-tier"
  project      = "project"
  prefix       = "app1"
  subnet_range = "10.150.8.0/24"
  web          = true
  app          = true
  database     = true

  webserver_instance_config = {
    disk_image   = "rhel-7-v20200403"
    disk_size    = "200"
    disk_type    = "pd-ssd"
    target_size  = "1"
    machine_type = "n1-standard-1"
  }

  app_server_instance_config = {
    disk_image   = "rhel-7-v20200403"
    disk_size    = "200"
    disk_type    = "pd-ssd"
    target_size  = "1"
    machine_type = "n1-standard-1"
  }

  database_instance_config = {
    disk_image   = "rhel-7-v20200403"
    disk_size    = "200"
    disk_type    = "pd-ssd"
    target_size  = "1"
    machine_type = "n1-standard-1"
  }
}