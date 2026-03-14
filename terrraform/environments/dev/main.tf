module "billing_api" {

  source = "../../modules/api-service"

  service_name = "billing-api"
  tenant_name  = "tenantA"

  lambda_source_path = "../../../services/sample-api/function.zip"

  region = "us-east-1"

}

#Dynamically Create Services

module "services" {

  for_each = {
    for svc in local.services :
    "${svc.tenant}-${svc.name}" => svc
  }

  source = "../../modules/api-service"

  service_name = each.value.name
  tenant_name  = each.value.tenant

  lambda_source_path = "../../../services/${each.value.name}/function.zip"

  region = "us-east-1"

}

#Now Terraform automatically creates infrastructure for every service in the registry.