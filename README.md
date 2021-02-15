# pre-commit

This is a set of [`pre-commit`] hooks for development across multiple languages.

Hooks:
* `todo-tags`: ensure all TODO comments reference a JIRA ticket (or any regex matcher)
* `todo-branch-tags`: show all TODOs tagged with the ticket reference in the branch name
* `branch-name-check`: checks branch names adhere to the regex `^(feature|bugfix|release|hotfix)\/.+`
* `go-test`: runs `go test ./...` at the repo root
* `go-dep-check`: ensure all your 3rd party Go packages are vendored (see [dep])
* `go-goimports`: ensure all the Go imports are included and ordered
* `go-golangci-lint`: a copy of the [official lint
  config](https://github.com/golangci/golangci-lint/commit/09677d574ea6cd05141022aa90b88b6598bfa1a1)
  without forcing the `--fix` argument
* `rust-check`: runs `cargo check` against all features & targets
* `rust-clippy`: runs `cargo clippy` lints in the repo root
* `rust-test`: runs `cargo test` at the repo root, includes all targets/features/examples/benches
* `rust-fmt`: runs `cargo fmt --all`
* `r-stylr`: runs [`stylr`] to format R code
* `r-lintr`: static analysis of R code with [`lintr`]
* `buf-lint`: runs [`buf`] lints against protobuf files
* `buf-breaking`: protobuf breaking change detection using [`buf`]

## Example config

```yaml
repos:
  - repo: https://github.com/domodwyer/pre-commit
    rev: master
    hooks:
      - id: todo-tags                      # Requires python
        stages: [commit, push, manual]
        args: ["--tag=DEV"]                # JIRA ticket tag (defaults to DEV)
        # args: ["--regex='.*'"]           # Or specify your own regex
      
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
      
      - id: go-goimports
        stages: [commit, push, manual]
        types: [go]
        exclude: \.pb.go$                  # Ignore generated protobuf files
        args: ["-local=itsallbroken.com"]  # Separate local imports
      
      - id: go-dep-check
        stages: [push, manual]
        types: [go]
      
      - id: go-golangci-lint
        args: [--new-from-rev=origin/master]
        stages: [commit, push]
        types: [go]
        exclude: \.pb.go$
      
      - id: rust-check
        stages: [commit, push]
      
      - id: rust-clippy
        # args: [                          # Optionally override default configured lints
        #  "-D rust_2018_idioms",
        #  "-D missing_docs",
        #]
        stages: [commit, push]
      
      - id: rust-test
        stages: [commit, push]
      
      - id: rust-fmt
        stages: [commit, push]
      
      - id: r-stylr
        stages: [commit, push]
      
      - id: r-lintr
        stages: [commit, push]
        stages: [commit, push]
      
      - id: buf-lint
        stages: [commit, push]
      
      - id: buf-breaking
        # Checks against 'master' branch by defaut, change with:
        # args: [".git#tag=v1.0.0"]
        stages: [commit, push]
```

## Tagged TODOs

New TODOs introduced into the codebase should be tracked in JIRA so they're
eventually done!

The `todo-tags` hook searches changed files for `TODO` comments (lines prefixed
by `#` or `//`) that do not reference a JIRA ticket. A valid TODO is in the
form: `TODO(DEV-4242)`, where the `DEV` tag is configurable, and `4242` is the
ticket number.

Instead for more flexibility, you can specify a custom regex to validate TODO
tags with instead:

```yaml
      - id: todo-tags
        stages: [commit, push, manual]
        args: ["--regex='(dom|clive)'"] 
```

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
[`lintr`]: https://github.com/jimhester/lintr
[`buf`]: https://buf.build/