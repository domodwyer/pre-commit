# pre-commit

This is a set of [`pre-commit`] hooks for (primarily Go) development.

Hooks:
* `go-test`: runs `go test ./...` at the repo root
* `goimports`: ensure all the imports are included
* `dep-check`: ensures all your 3rd party packages are vendored (see [dep])

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
```

[`pre-commit`]: https://pre-commit.com
[dep]: https://github.com/golang/dep