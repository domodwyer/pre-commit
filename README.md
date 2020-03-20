# pre-commit

This is a set of [`pre-commit`] hooks for (primarily Go) development.

Hooks:
* `go-test`: runs `go test ./...` at the repo root
* `goimports`: ensure all the imports are included
* `dep-check`: ensure all your 3rd party packages are vendored (see [dep])
* `branch-name-check`: checks branch names adhere to the regex `^(feature|bugfix|release|hotfix)\/.+`
* `todo-jira-check`: ensure all TODO comments reference a JIRA ticket
* `find-branch-todos`: show all TODOs tagged with the ticket reference in the branch name

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

## Tagged TODOs

New TODOs introduced into the codebase should be tracked in JIRA so they're
eventually done!

The `todo-jira-check` hook searches changed files for `TODO` comments (lines
prefixed by `#` or `//`) that do not reference a JIRA ticket. A valid TODO is in
the form: `TODO(DEV-4242)`, where the `DEV` tag is configurable, and `4242` is
the ticket number.

The `find-branch-todos` is useful as a [`post-checkout`] hook to print all TODOs
tagged with the ticket reference in the branch name. If you checkout a branch
called `feature/DEV-4242-bananas`, all `TODO(DEV-4242)` comments will be shown.

### Adding new hooks

When adding new hooks you can run `pre-commit try-repo .` for a quick syntax check.

[`pre-commit`]: https://pre-commit.com
[dep]: https://github.com/golang/dep
[`post-checkout`]: https://git-scm.com/docs/githooks#_post_checkout