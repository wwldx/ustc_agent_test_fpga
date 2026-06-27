# Scripts

This directory contains repository maintenance and deterministic helper scripts.

Current scripts:

- `check_repo_safety.sh`: blocks obvious public-repo leaks before commit or push.
- `doctor.sh`: reports local tool availability.

Experiment-specific scripts should live inside the relevant `experiments/<topic>/` directory unless they are reusable.
