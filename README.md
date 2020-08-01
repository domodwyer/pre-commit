# pre-commit

This is a set of [`pre-commit`] hooks for (primarily Go) development.

Hooks:
* `todo-tagged-jira`: ensure all TODO comments reference a JIRA ticket
* `todo-branch-tags`: show all TODOs tagged with the ticket reference in the branch name
* `branch-name-check`: checks branch names adhere to the regex `^(feature|bugfix|release|hotfix)\/.+`
* `go-test`: runs `go test ./...` at the repo root
* `go-dep-check`: ensure all your 3rd party Go packages are vendored (see [dep])
* `goimports`: ensure all the Go imports are included and ordered
* `golangci-lint`: a copy of the [official lint
  config](https://github.com/golangci/golangci-lint/commit/09677d574ea6cd05141022aa90b88b6598bfa1a1)
  without forcing the `--fix` argument
* `rust-clippy`: runs `cargo clippy` lints in the repo root
* `r-stylr`: runs [`stylr`] to format R code

## Example config

```yaml
repos:
  - repo: https://github.com/domodwyer/pre-commit
    rev: master
    hooks:
      - id: todo-tagged-jira               # Requires python
        stages: [commit, push, manual]
        args: ["--tag=DEV"]                # JIRA ticket tag (defaults to DEV)
      
      - id: todo-branch-tags
        stages: [post-checkout, manual]    # Show tags when checking out
        args: ["DEV"]                      # JIRA ticket tag
      
      - id: branch-name-check
        stages: [push]

      - id: go-test
        stages: [commit, push]
        types: [go]
        exclude: \.pb.go$                  # Ignore generated protobuf files
        args: ["-timeout=30s"]             # Set a deadline (fast tests == happy developers)
      
      - id: goimports
        stages: [commit, push, manual]
        types: [go]
        exclude: \.pb.go$                  # Ignore generated protobuf files
        args: ["-local=itsallbroken.com"]  # Separate local imports
      
      - id: go-dep-check
        stages: [push, manual]
        types: [go]
      
      - id: golangci-lint
        args: [--new-from-rev=origin/master]
        stages: [commit, push]
        types: [go]
        exclude: \.pb.go$
      
      - id: rust-clippy
        stages: [commit, push]
      
      - id: r-stylr
        stages: [commit, push]
```

## Tagged TODOs

New TODOs introduced into the codebase should be tracked in JIRA so they're
eventually done!

The `todo-tagged-jira` hook searches changed files for `TODO` comments (lines
prefixed by `#` or `//`) that do not reference a JIRA ticket. A valid TODO is in
the form: `TODO(DEV-4242)`, where the `DEV` tag is configurable, and `4242` is
the ticket number.

The `todo-branch-tags` is useful as a [`post-checkout`] hook to print all TODOs
tagged with the ticket reference in the branch name. If you checkout a branch
called `feature/DEV-4242-bananas`, all `TODO(DEV-4242)` comments will be shown:

```text
$ git checkout feature/DEV-4242-great-feature

Switched to branch 'feature/DEV-4242-great-feature'
Outstanding TODOs for the current branch.................................Failed
- hook id: find-branch-todos
- exit code: 1

./some/path/client.go
240:	// TODO(DEV-4242): lock mutex before call

./some/path/client_test.go
2650:	// TODO(DEV-4242): add test case for new feature
```

### Adding new hooks

When adding new hooks you can run `pre-commit try-repo .` for a quick syntax check.

[`pre-commit`]: https://pre-commit.com
[dep]: https://github.com/golang/dep
[`post-checkout`]: https://git-scm.com/docs/githooks#_post_checkout
[`stylr`]: https://styler.r-lib.org/