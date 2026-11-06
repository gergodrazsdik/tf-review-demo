# tf-review-demo
Template: OpenTofu project reviewed by tf-review

## Using this template

A repo made from this template changes the `locals` at the top of `infra/main.tf`: the workload names the resource group, every resource and the `project` tag, and the owner fills the `owner` tag. Then it's onboarded with one entry in `tf-review`'s bootstrap `repos` map, whose `target_resource_group` is `rg-<workload>-<environment>`. The steps are in `tf-review`'s `docs/plan.md` (M4's gate).
