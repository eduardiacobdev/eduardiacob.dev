# tflint config for infra/ (CI job "terraform"). The terraform ruleset is
# bundled with tflint, so no plugin download is needed.
config {
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
