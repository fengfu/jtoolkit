# AGENTS.md

## Cursor Cloud specific instructions

JToolkit is a collection of interactive Bash shell scripts for Java troubleshooting on Linux. There is no build system, no package manager, and no automated test suite.

### Prerequisites

- **Bash** and **JDK** (provides `jstack`, `jmap`, `jstat`, `jcmd`) must be available.
- **A running Java process** is required for most tools to do anything useful. Start one with e.g. `java -cp /tmp SimpleApp &` after compiling a trivial class.
- `wget` is used by scripts to download sub-scripts and third-party tools on first run.

### Linting

- **Syntax check**: `bash -n <script.sh>` (all 19 scripts pass).
- **Shellcheck**: `shellcheck --severity=error **/*.sh` — reports pre-existing issues in `cpu/show_busy_threads_with_percent.sh` and `jvm/jvm_option_generate.sh`; these are upstream bugs, not regressions.

### Running

- Entry point: `source jtoolkit.sh` (interactive menu). For non-interactive testing, pipe choices: `printf "2\n<PID>\nq\n" | bash memory/sub_menu.sh`.
- The main `jtoolkit.sh` script changes `cwd` to `$HOME/jtoolkit` and attempts to download itself from GitHub. When testing locally, run submenus directly from their directories (e.g. `cd memory && bash sub_menu.sh`).
- `jvm/jvm_option_check.sh` uses `#!/bin/sh` but contains bash-only syntax (`[[`); it will error on strict POSIX shells. This is a known upstream issue.

### Testing

There is no automated test suite. Validate changes with `bash -n` syntax checks and `shellcheck`.
