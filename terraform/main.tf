terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.83.0"
    }

    grafana = {
         source  = "grafana/grafana"
         version = "1.40.1"
      }
  }
}

provider "grafana" {
   alias = "azure"
   url   = ""
  #  auth  = file(${path.module}/token.txt)
}



resource "null_resource" "grafana_commands" {
  provisioner "local-exec" {
    command = <<-EOT
      az grafana service-account create --name grafana-view --service-account grafana-sa-one --role Admin
      az grafana service-account token create --name grafana-view --service-account grafana-sa-one --token grafana-sa-token --time-to-live 1d > git_token.json
      cat git_token.txt | jq -r .key > token.json
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
   triggers = {
    grafana_commands = timestamp()
  }
}

# Read the token from the file
data "local_file" "grafana_token" {
  # depends_on = [null_resource.grafana_commands]
  filename = "${path.module}/token.json"
}

# Output the Grafana token as a variable
output "grafana_token" {
  value = data.local_file.grafana_token.content
}
