# ---------------------------------------------------------------------------
# Tags — bank tagging standard enforcement
#
# Pure computation module (no Azure resources). Merges the mandatory bank tags,
# the platform auto-applied tags, and any workload-specific additional tags into
# a single map. Every other module passes this output straight to the `tags`
# argument on its resources.
#
# Precedence (lowest -> highest): additional < mandatory < platform.
# Additional tags can therefore ADD workload-specific keys but can never
# override a mandatory or platform-standard tag.
# ---------------------------------------------------------------------------

locals {
  # Auto-applied platform tags — consistent across every resource in the repo.
  platform_tags = {
    "managed-by" = "terraform"
    environment  = var.environment
    region       = var.region
    workload     = var.workload
    repo         = "vdi-terraform"
  }

  tags = merge(
    var.additional,      # lowest precedence
    var.mandatory,       # mandatory bank tags
    local.platform_tags, # highest precedence — always wins
  )
}
