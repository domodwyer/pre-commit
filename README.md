# pre-commit

This is a set of [`pre-commit`] hooks for (primarily Go) development.

Hooks:
* `go-test`: runs `go test ./...` at the repo root
* `goimports`: ensure all the imports are included
* `dep-check`: ensure all your 3rd party packages are vendored (see [dep])
* `todo-jira-check`: ensure all TODO comments reference a JIRA ticket

## Example config

```yaml
repos:
  - repo: https://github.com/domodwyer/pre-commit
    rev: v1.0.0
    hooks:
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
      
      - id: dep-check
        stages: [push, manual]
        types: [go]
      
      - id: todo-jira-check                # Requires python
        stages: [commit, push, manual]
        args: ["--tag=DEV"]                # JIRA ticket tag (defaults to DEV)
```

### TODO JIRAs

New TODOs introduced into the codebase should be tracked in JIRA so they're
eventually done!

The `todo-jira-check` hook searches changed files for `TODO` comments (lines
prefixed by `#` or `//`) that do not reference a JIRA ticket. A valid TODO is in
the form: `TODO(DEV-4242)`, where the `DEV` tag is configurable, and `4242` is
the ticket number.

[`pre-commit`]: https://pre-commit.com
[dep]: https://github.com/golang/dep