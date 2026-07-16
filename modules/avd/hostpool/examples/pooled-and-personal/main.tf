# ---------------------------------------------------------------------------
# Example: two AVD host pools in UK South — one Pooled, one Personal.
#
# Note on load balancing:
#   - Pooled  pools support BreadthFirst / DepthFirst.
#   - Personal pools MUST use Persistent (Azure rejects DepthFirst here).
#   - maximum_sessions_allowed applies to Pooled pools only.
# ---------------------------------------------------------------------------

module "hostpool_pooled" {
  source = "../.."

  name                = "vdi-mult-pooled"
  resource_group_name = var.resource_group_name
  location            = "uksouth"

  host_pool_type           = "Pooled"
  load_balancer_type       = "DepthFirst"
  maximum_sessions_allowed = 18

  tags = var.tags
}

module "hostpool_personal" {
  source = "../.."

  name                = "vdi-mult-personal"
  resource_group_name = var.resource_group_name
  location            = "uksouth"

  host_pool_type     = "Personal"
  load_balancer_type = "Persistent" # DepthFirst is not valid for Personal pools

  tags = var.tags
}
