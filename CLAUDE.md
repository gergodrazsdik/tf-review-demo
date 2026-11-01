# tf-review-demo

GitHub template for an OpenTofu project reviewed by `tf-review`. Its seeded bad-PR branches double as the reviewer's eval suite. The plan is in `../tf-review/docs/plan.md`.

## Commands

- `just lint`: every check the CI `lint` job runs
- `just hooks`: install the git hooks

## Conventions

- Plans run on every PR through the plan identity. Applies run on merge, in CI, behind the `prod` environment approval: agents never apply.
- Resources follow ADR-001 (names) and ADR-002 (tags) in `tf-standards`, except on seeded branches that break them on purpose.
- Bootstrap in `tf-review` creates this repo's state container, identities, Actions variables and `prod` environment.
- `main` takes squash-merged PRs only, and third-party actions are pinned to full SHAs with `pinact`.
