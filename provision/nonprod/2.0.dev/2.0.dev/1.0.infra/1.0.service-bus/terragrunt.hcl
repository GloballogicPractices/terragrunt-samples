terraform {
  source = "../../../../../../modules/service-bus"
}

dependency "resource_group" {
  config_path = "../../../1.0.infra/1.0.rg-app/"

  mock_outputs = {
    resource_group_name = "test-group-id"
  }

  mock_outputs_allowed_terraform_commands = ["plan"]

}

locals {
  common_vars = yamldecode(file("${find_in_parent_folders("nonprod-common.yaml")}"))
}

inputs = {

  role                = "app"
  resource_group_name = dependency.resource_group.outputs.resource_group_name

  topics = [
    {
      name = "sb-topic-1"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "sb-topic-1"
          rights = ["listen", "send"]
        }
      ]
    },
    {
      name = "sb-topic-2"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "sb-topic-2"
          rights = ["listen"]
        }
      ]
    },
    {
      name = "sb-topic-3"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "sb-topic-3"
          rights = ["send"]
        }
      ]
    }
  ]
}


include {
  path = find_in_parent_folders()
}

