packer {
  required_version = ">= 1.7.0"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

locals {
  content = {
    "/meta-data" = file("${path.root}/www/meta-data")
    "/user-data" = templatefile(
      "${path.root}/www/user-data",
      {
        password = var.password
        ssh_key  = var.ssh_public_key
        user     = var.user
        packages = []
      }
    )
  }
  date             = formatdate("YYYYMMDD", timestamp())
  full_version     = "${local.date}.${local.version}"
  manifest         = fileexists(local.manifest_name) ? jsondecode(file(local.manifest_name)) : { "builds" : [], "last_run_uuid" : "" }
  manifest_name    = "${var.output_directory}/packer-manifest-${var.name}-${local.date}.json"
  name             = "${var.name}_${local.full_version}"
  output           = "${var.output_directory}/${local.name}.vmwarevm"
  shutdown_command = "sudo shutdown -P now"
  version          = length(local.versions) == 0 ? 0 : max(local.versions...) + 1
  versions         = [for build in local.manifest["builds"] : split(".", build.custom_data.version)[0] == local.date ? split(".", build.custom_data.version)[1] : -1]
}

source "vmware-iso" "ubuntu-2210" {
  boot_command           = var.boot_command
  cpus                   = var.cpus
  disk_adapter_type      = "nvme"
  disk_size              = var.disk_size
  guest_os_type          = "arm-ubuntu-64"
  headless               = true
  http_content           = local.content
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  memory                 = var.memory
  network_adapter_type   = "e1000e"
  output_directory       = local.output
  shutdown_command       = local.shutdown_command
  ssh_handshake_attempts = 100
  ssh_password           = var.password
  ssh_timeout            = var.ssh_timeout
  ssh_username           = var.user
  usb                    = true
  version                = 20
  vm_name                = local.name
  vmx_data = {
    "usb_xhci.present"                      = "TRUE"
    "isolation.tools.hgfsServerSet.disable" = "TRUE"
    "isolation.tools.hgfs.disable"          = "TRUE"
  }
}

build {
  sources = [
    "source.vmware-iso.ubuntu-2210"
  ]

  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }

  provisioner "shell" {
    inline = [
      "sudo apt clean",
      "sudo e4defrag / >> /dev/null",
      "sudo dd if=/dev/zero of=/EMPTY bs=1M || true",
      "sudo rm -f /EMPTY",
      "sync",
      "sudo vmware-toolbox-cmd disk shrink /"
    ]
  }

  post-processor "manifest" {
    output = local.manifest_name
    custom_data = {
      version = local.full_version
    }
  }

  post-processor "vagrant" {
    keep_input_artifact  = false
    vagrantfile_template = "./Vagrantfile"
    output               = "${var.output_directory}/${local.name}_arm64_{{.Provider}}.box"
  }
}
