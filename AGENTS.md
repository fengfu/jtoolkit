# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

JToolkit is a CLI toolkit of Bash shell scripts for Java troubleshooting on Linux. There is no build system, no package manager, and no automated test framework. The main entry point is `jtoolkit.sh`, which presents an interactive menu. Sub-modules live in directories (`cpu/`, `memory/`, `gc/`, `swap/`, `disk/`, `net/`, `jvm/`, `hardware/`, `tools/`), each with a `sub_menu.sh` entry point.

### System dependencies

The environment requires: `bash`, JDK (provides `jmap`, `jstat`, `jcmd`, `jstack`), `wget`, `bc`, and `shellcheck` (for linting). These are pre-installed by the update script.

### Linting

Run `shellcheck` for static analysis of all shell scripts:

```
shellcheck -s bash *.sh **/*.sh
```

All findings are pre-existing in the upstream codebase.

### Running the toolkit

All scripts are interactive (use `read -p` for user input). To test non-interactively:

- **Main menu**: `echo "q" | bash jtoolkit.sh`
- **CPU busy threads**: `bash cpu/show_busy_threads_with_percent.sh -p <JAVA_PID> -c 1`
- **JVM option check**: `echo "<PID>" | bash jvm/jvm_option_check.sh`

A running Java process is needed for most features. Create a simple one:

```
cat > /tmp/BusyApp.java << 'EOF'
public class BusyApp {
    public static void main(String[] args) throws InterruptedException {
        while (true) { Thread.sleep(1000); }
    }
}
EOF
cd /tmp && javac BusyApp.java && java BusyApp &
```

### Key gotchas

- The `jtoolkit.sh` script changes directories to `$HOME/jtoolkit` at startup and tries to `wget` scripts from GitHub. When running from the repo, use sub-module scripts directly instead.
- Many scripts use `sudo` to inspect Java processes owned by other users. In the cloud environment, the test Java process should be started by the same user to avoid sudo issues.
- The GC sub-module features (`gc/`) are stubs that print "under development" (开发中).
- Scripts assume `yum` for package installation (e.g., `unzip`). On Ubuntu-based environments, this will not work; install system packages with `apt-get` instead if needed.
