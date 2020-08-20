module "resource_group" {
  source      = "../../"
  role        = "unit-test"
  environment = "infra-test"
  client_name = "voyager"
  location    = "centralus"
  owner       = "dev@vca.com"
  creator     = "gl-devops@vca.com"
  vendor      = "globallogic"
  tags = {
    test = "test1"
  }
}

