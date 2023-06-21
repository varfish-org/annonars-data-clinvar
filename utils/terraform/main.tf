# Mangement of the GitHub project.

resource "github_repository" "annonars-data-clinvar" {
  name        = "annonars-data-clinvar"
  description = "Clinvar data builds for annonars"

  has_issues = true
  visibility = "public"

  allow_auto_merge       = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
  has_downloads          = true
  delete_branch_on_merge = true

  squash_merge_commit_message = "BLANK"
  squash_merge_commit_title   = "PR_TITLE"
}
