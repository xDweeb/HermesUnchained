# Changelog

All notable changes to HermesUnchained are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-03

### Added

- Unified `scripts/ops/hermes-unchained` lifecycle CLI and `bin/hermes-unchained` executable alias.
- Start, stop, restart, status, logs, update, and clean commands.
- Retrying OmniRoute health checks before Hermes launches.
- Configurable local settings through `.env` and `.env.example`.
- Makefile shortcuts for setup and daily operations.
- Project architecture, CLI reference, security guidance, and contributor documentation.
- Isolated Hermes home and loopback-only OmniRoute container defaults.
