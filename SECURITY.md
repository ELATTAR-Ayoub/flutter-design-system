# Security Policy

## Supported state

This repository is at version `0.0.1`, its first public release. Security fixes may land before broader roadmap work, but the project should not be treated as formally hardened or compliance-certified by default.

`elattar_cli` writes source into other people's projects, which is the surface most worth reporting against. (It is not yet published to pub.dev — code, tests and CI gates are complete, but the publish itself is still pending.) Fixes to it ship as a new CLI version. A published registry version is never rewritten, so a corrected payload also ships as a new version rather than as a silent replacement of what people already installed.

## Reporting a vulnerability

Please do not open public issues for suspected vulnerabilities.

Use GitHub's private vulnerability reporting flow for this repository if it is enabled:

1. Open the repository's `Security` tab.
2. Choose the option to privately report a vulnerability.
3. Include the affected component, impact, reproduction steps, and any suggested mitigation.

If private reporting is not available in the repository UI, open a minimal public issue that does not disclose exploit details and asks a maintainer to establish a private follow-up path.

## What to include

Helpful reports usually include:

- the affected package area, component, example surface, or CLI or registry path,
- the exact commit, branch, or file set tested,
- reproduction steps,
- expected versus actual behavior,
- impact and exploitability,
- and whether the issue depends on debug-only, example-only, or production package usage.

## Response goals

Maintainers will try to:

- acknowledge a report,
- validate the impact,
- work on a fix or mitigation,
- and publish a coordinated resolution once public disclosure is appropriate.

Response time may vary because this repository is still in an early release stage.

## Security priorities for this repository

Areas likely to matter most here include:

- package API misuse that can break app safety expectations,
- accessibility regressions that suppress critical feedback,
- CLI or registry behaviour that writes outside where it says it writes, overwrites a consumer's files unexpectedly, or installs a payload whose hash was not verified,
- anything that would let a registry, a mirror, or a redirect cause the CLI to write a file no manifest declared,
- dependency or asset provenance issues,
- and example or documentation guidance that could lead users into insecure integration patterns.

## Disclosure guidance

Please keep vulnerability details private until maintainers confirm that public disclosure is safe.
