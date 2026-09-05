# Contributing to HermesUnchained

Thank you for helping improve HermesUnchained.

## Development setup

1. Fork and clone the repository.
2. Create a focused branch from `main`.
3. Run `make setup` and review the generated `.env`.
4. Make the smallest change that solves the issue.
5. Run the checks below before opening a pull request.

```bash
bash -n scripts/ops/hermes-unchained start-hermes-omni.sh start-omniroute.sh
make --dry-run setup start stop status logs clean
./bin/hermes-unchained --help
./bin/hermes-unchained status
```

## Pull requests

- Explain the motivation, behavior change, and test evidence.
- Keep secrets, personal configuration, runtime data, and generated state out of commits.
- Update README and CHANGELOG when behavior or user-facing commands change.
- Use clear, imperative commit messages; Conventional Commits are encouraged.
- Preserve the isolated-home and loopback-only security defaults.

## Reporting security issues

Do not publish credentials or exploitable details in a public issue. Open a private GitHub
security advisory for the repository instead.

By contributing, you agree that your contribution is licensed under the MIT License.
