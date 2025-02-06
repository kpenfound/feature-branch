export GITHUB_TOKEN=$(gh auth token)
_EXPERIMENTAL_DAGGER_RUNNER_HOST=tcp://localhost:1234 ~/bin/dagger-llm shell -m github.com/shykes/melvin/workspace <<'EOF'
# LLM work
agentwork=$(llm |
with-workspace $(github.com/shykes/melvin/workspace --start $(git https://github.com/shykes/x | head | tree)) | with-prompt "look around the repository and summarize its purpose in /README.md" | workspace)
# PR
github.com/kpenfound/feature-branch | with-github-token env:GITHUB_TOKEN | create github.com/shykes/x "add_readme_llm" --fork-name "shykes-x" | with-changes $($agentwork | dir | without-directory .git) | pull-request "Add Readme" "This adds a basic readme"
EOF
