locals {
  foundation = {
    "adam"           = local.users.adam
    "jdn"            = local.users.jdn
    "joel"           = local.users.joel
    "jon"            = local.users.jon
    "marcoieni"      = local.users.marcoieni
    "paullenz"       = local.users.paullenz
    "rustfoundation" = local.users.rustfoundation
    "tobias"         = local.users.tobias
    "walter"         = local.users.walter
  }
}

resource "datadog_role" "foundation" {
  name = "Rust Foundation"

  dynamic "permission" {
    for_each = toset([
      data.datadog_permissions.all.permissions.dashboards_write,
      data.datadog_permissions.all.permissions.dashboards_public_share,
      data.datadog_permissions.all.permissions.notebooks_write,
      data.datadog_permissions.all.permissions.logs_generate_metrics,
      data.datadog_permissions.all.permissions.metrics_metadata_write,
    ])

    content {
      id = permission.value
    }
  }
}

resource "datadog_team" "foundation" {
  name        = "Rust Foundation"
  description = "The staff of the Rust Foundation"
  handle      = "foundation"
}

resource "datadog_team_membership" "foundation" {
  for_each = local.foundation

  team_id = datadog_team.foundation.id
  user_id = datadog_user.users[each.key].id
}
