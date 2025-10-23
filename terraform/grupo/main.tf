resource "google_cloud_identity_group" "grupo_engenheiros_dados" {
  display_name         = "grupo_engenheiros_dados"

  parent = "customers/C03jnxeie" # ID do cliente do Cloud Identity / Google Workspace

  group_key {
            id = "grupo_engenheiros_dados@abemcomum.org"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

resource "google_cloud_identity_group_membership" "membros_engenheiros" {

  for_each = toset([
    "patrick.teixeira@basedosdados.org",
    "gabriel.pisa@basedosdados.org",
    "luiza.vilasboas@basedosdados.org",
    "artemisia.weyl@basedosdados.org",
    "laura.amaral@basedosdados.org"]
  )


  group = "groups/${google_cloud_identity_group.grupo_engenheiros_dados.name}"

  preferred_member_key{
    id = each.value
  }

  roles {
    name = "MEMBER"
  }
}
