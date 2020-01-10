provider "azuredevops" {
  version = ">= 0.0.1"
}

resource "azuredevops_project" "project" {
  project_name       = "Sample Project"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_serviceendpoint_github" "github_serviceendpoint" {
  project_id             = azuredevops_project.project.id
  service_endpoint_name  = "GitHub Service Connection"
  github_service_endpoint_pat = "xxxxxxxx"
}


resource "azuredevops_build_definition" "nightly_build" {
  project_id      = azuredevops_project.project.id
  agent_pool_name = "Hosted Ubuntu 1604"
  name            = "Nightly Build"
  path            = "\\"

  repository {
    repo_type             = "GitHub"
    repo_name             = "iojas/django_ci_cd"
    branch_name           = "master"
    yml_path              = "samplebuild.yml"
    service_connection_id = azuredevops_serviceendpoint_github.github_serviceendpoint.id
  }
}