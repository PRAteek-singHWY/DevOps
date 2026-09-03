# Git and GitHub

## At a glance

Two experiments in a throwaway repository. The first shows what `-a` really adds to
`git commit` and where it stops. The second moves a single commit from one branch to another
with `git cherry-pick`, leaving its neighbours behind.

## Concepts

### Three places your changes can be

```
 working tree  ──git add──►  index (staging area)  ──git commit──►  repository
 (files on disk)            (what the next commit     (permanent history)
                              will contain)
```

Every Git command is easier to reason about once you ask "which of the three is this touching?"

| Command | Moves changes from | To |
|---|---|---|
| `git add file` | working tree | index |
| `git commit -m` | index | repository |
| `git commit -a -m` | working tree (tracked files only) then index | repository |
| `git restore file` | index | working tree |
| `git restore --staged file` | index | (unstaged, back to working tree) |

`-a` is shorthand for "stage every *tracked* file that changed, then commit". It never touches
files Git has not seen before. New files always need an explicit `git add`.

### Cherry-pick

`git cherry-pick <commit>` takes the *diff* introduced by one commit and applies it on top of
the current branch as a **new commit**. The message and author date are reused; the hash is
new because the parent is different. The original commit is untouched.

Use it when a branch has one change you want now and several you do not. Do not use it as a
substitute for merging a whole branch: repeated cherry-picks create duplicate commits that make
later merges confusing.

## Lab

### Experiment 1: `git commit -m` vs `git commit -a -m`

```bash
mkdir gitlab && cd gitlab
git init -q -b main .
git config user.name  "Lab User"
git config user.email "lab@example.com"

echo "todo: learn git" > todo.txt
git add todo.txt
git commit -q -m "first version of todo"
git log --oneline
```

Now modify the tracked file and try to commit without staging:

```bash
echo "todo: practice -a flag" >> todo.txt
git status -s                    #  M todo.txt  (modified, not staged)
git commit -m "commit without -a"
```

```text
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   todo.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

Nothing was committed. The change sits in the working tree, and the index is identical to the
last commit. Now with `-a`:

```bash
git commit -a -m "commit with -a picks up the tracked change"
# [main 62b474a] commit with -a picks up the tracked change
#  1 file changed, 1 insertion(+)
```

Finally, prove that `-a` ignores untracked files:

```bash
echo "new file" > untracked.txt
git status -s                    # ?? untracked.txt
git commit -a -m "does -a include untracked?"
```

```text
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	untracked.txt

nothing added to commit but untracked files present (use "git add" to track)
```

**What you should see**

| Step | Result | Why |
|---|---|---|
| `commit -m` after editing | Nothing committed | Index still matches HEAD |
| `commit -a -m` after editing | One commit, one insertion | `-a` staged the tracked file first |
| `commit -a -m` with a new file | Nothing committed | `-a` skips untracked files |

### Experiment 2: `git cherry-pick`

Build a `hotfix` branch with three commits, only one of which belongs on `main`.

```bash
echo "config v1" > config.txt
git add config.txt && git commit -q -m "Add config"

git switch -c hotfix
echo "logging on" > logging.txt
git add logging.txt && git commit -q -m "hotfix: enable logging"

echo "config v1 + port fix" > config.txt
git commit -q -a -m "hotfix: correct the port in config"

echo "temp debug" > debug.txt
git add debug.txt && git commit -q -m "hotfix: temporary debug file"

git log --oneline
```

```text
951a91c hotfix: temporary debug file
6480118 hotfix: correct the port in config      <-- the one we want on main
e69654f hotfix: enable logging
6e0fc16 Add config
62b474a commit with -a picks up the tracked change
5f6bfdb first version of todo
```

Pick only the port fix:

```bash
git switch main
git cherry-pick 6480118
# [main 5dbc089] hotfix: correct the port in config
#  1 file changed, 1 insertion(+), 1 deletion(-)

git log --oneline
ls
cat config.txt
```

```text
5dbc089 hotfix: correct the port in config
6e0fc16 Add config
62b474a commit with -a picks up the tracked change
5f6bfdb first version of todo

config.txt  todo.txt  untracked.txt
config v1 + port fix
```

**What you should see**

- `main` has the port fix. `logging.txt` and `debug.txt` do not exist on `main`.
- The commit on `main` has a **new hash** (`5dbc089`, not `6480118`) but the same message
  and diff. Different parent, different hash.
- `hotfix` is unchanged. `git log hotfix --oneline` still shows all three commits.

Compare both branches side by side:

```bash
git log --oneline --graph --all
```

### Useful cherry-pick forms

```bash
git cherry-pick A B C          # several commits, in that order
git cherry-pick A..B           # every commit after A up to and including B
git cherry-pick -n <commit>    # apply to index and tree, but do not commit yet
git cherry-pick -x <commit>    # append "(cherry picked from commit ...)" to the message
git cherry-pick --continue     # after fixing a conflict
git cherry-pick --abort        # give up and restore the branch
```

## Pitfalls

- Believing `git commit -a` committed the new file you just created. Run `git status` before
  and after; the `??` marker means Git has never seen it.
- Using `git add .` reflexively. It stages everything, including files you did not mean to
  commit. Prefer `git add -p` to review hunks, or name the files.
- Cherry-picking a merge commit. It has two parents, so Git needs `-m 1` to know which side
  to take the diff from. Usually a sign that you want a merge, not a pick.
- Cherry-picking the same change into a long-lived branch that will later be merged. The
  change lands twice in history. Use `-x` so the duplicate is at least traceable.
- Forgetting that a cherry-pick can conflict just like a merge. Read the conflict markers,
  fix, `git add`, then `--continue`.

## Check yourself

1. In one sentence, what is the index for?
2. You ran `git commit -a -m "..."` and a new file is still missing from the commit. Why?
3. Why does a cherry-picked commit get a new hash when the message and diff are identical?
4. What is the difference between `git cherry-pick A..B` and `git cherry-pick A B`?
5. When would `git cherry-pick -n` be more useful than a plain pick?
