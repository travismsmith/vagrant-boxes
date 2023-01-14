variable "boot_command" {
  type = list(string)
  default = [
    "e",
    "<down><down><down><end><bs><bs><bs>",
    # "https://superuser.com/questions/1556083/ubuntu-server-20-04-autoinstall"
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---",
    "<f10>"
  ]
}

variable "cpus" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = number
  default = 10240
}

variable "home_dir" {
  type    = string
  default = env("HOME")
}

variable "iso_checksum" {
  type    = string
  default = "file:https://cdimage.ubuntu.com/releases/22.10/release/SHA256SUMS"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.ubuntu.com/releases/22.10/release/ubuntu-22.10-live-server-arm64.iso"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "name" {
  type    = string
  default = "ubuntu-server-22.10"
}

variable "output_directory" {
  type    = string
  default = "Virtual Machines.localized"
}

variable "password" {
  type    = string
  default = "vagrant"
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
}

variable "ssh_timeout" {
  type    = string
  default = "30m"
}

variable "user" {
  type    = string
  default = "vagrant"
}
