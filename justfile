# List the recipes
default:
    @just --list

# Start Claude Code with the reviewer and standards repos in reach
[group('dev')]
claude *args:
    CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
      --add-dir ../tf-review --add-dir ../tf-standards {{ args }}

# Install the git hooks
[group('dev')]
hooks:
    lefthook install

# Run every pre-commit check on all files; the CI lint job runs this too
[group('dev')]
lint:
    tofu fmt -check -recursive .
    tflint --init
    tflint --recursive --config "$PWD/.tflint.hcl"
    yamllint --strict .
    actionlint
    pinact run --check
    shellcheck scripts/*.sh
    gitleaks git --no-banner
