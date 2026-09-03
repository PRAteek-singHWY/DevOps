# DevOps Practice Labs

A hands-on path through the DevOps basics: Linux, shell scripting, networking, Git, and
Docker. Every topic lives in its own folder with a README that explains the idea, walks
through a lab you can reproduce, shows the evidence from a real run, and ends with a few
questions to check your understanding.

## Learning path

Work through the folders in this order. Each one leans on the previous.

| # | Folder | What you practise | Time |
|---|---|---|---|
| 1 | [`Linux Fundamentals/`](Linux%20Fundamentals/README.md) | Inodes and links, creating users, reading the systemd journal, a command cheat sheet | 45 min |
| 2 | [`Shell Scripting/`](Shell%20Scripting/README.md) | A real script: variables, prompts, `mkdir`, `touch`, redirection, exit codes | 30 min |
| 3 | [`Networking Fundamentals/`](Networking%20Fundamentals/README.md) | A debugging toolkit: `ping`, `ip`, `ss`, `curl`, `wget`, `dig`, `traceroute` | 45 min |
| 4 | [`Git and Github/`](Git%20and%20Github/README.md) | The staging area, `commit -a`, and moving one commit with `cherry-pick` | 30 min |
| 5 | [`Docker Fundamentals/`](Docker%20Fundamentals/README.md) | Six Hello World services in six runtimes, plus a Compose file to run them all | 60 min |
| 6 | [`DockerFiles and Images/`](DockerFiles%20and%20Images/README.md) | Multi-stage builds: from a 365 MB toolchain to a 7 MB image | 30 min |
| 7 | [`Docker Networks/`](Docker%20Networks/README.md) | Bridge, host, and overlay networks, plus bind mounts | 60 min |

## How each lab is laid out

```
<Topic>/
├── README.md        concepts, lab steps, pitfalls, self-check
├── screenshots/     captured output from the run described in the README
└── ...              any code, Dockerfiles or configs the lab uses
```

Every README follows the same shape:

1. **At a glance**: the one-paragraph version.
2. **Concepts**: the mental model you need before typing anything.
3. **Lab**: numbered steps with the exact commands.
4. **What you should see**: expected output and screenshots.
5. **Pitfalls**: the mistakes that cost the most time.
6. **Check yourself**: short questions with no answers given. Look them up if unsure.

## Environment

- Host: macOS with Docker Desktop.
- Linux-only commands (`ip`, `ss`, `useradd`, `journalctl`, and so on) were run inside an
  `ubuntu:24.04` container. A one-liner to get the same shell:

  ```bash
  docker run -it --rm --hostname ubuntu-lab ubuntu:24.04 bash
  ```

- Docker labs need nothing beyond Docker itself. No language toolchains are installed on the
  host; every build happens inside a container.

## Conventions

- Commands are shown without a `$` prompt so they can be copied as-is. Output that is worth
  reading is shown in a separate block or described in prose.
- Host ports avoid the usual macOS collisions (5000 is AirPlay, 3000 is often a dev server).
- Run-time output such as `reports/` and `dist/` is ignored via `.gitignore`.

## Quick start

```bash
git clone https://github.com/PRAteek-singHWY/DevOps.git
cd DevOps

# run all six Hello World containers at once
docker compose -f "Docker Fundamentals/compose.yaml" up -d --build

# stop them again
docker compose -f "Docker Fundamentals/compose.yaml" down
```
