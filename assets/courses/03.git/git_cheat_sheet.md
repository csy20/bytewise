# Git Command Cheat Sheet

**Quick Reference Guide for Git Commands**

---

## 📋 Table of Contents
1. [Setup & Configuration](#setup--configuration)
2. [Creating Repositories](#creating-repositories)
3. [Basic Workflow](#basic-workflow)
4. [Branching & Merging](#branching--merging)
5. [Remote Operations](#remote-operations)
6. [Undoing Changes](#undoing-changes)
7. [Stashing](#stashing)
8. [Viewing History](#viewing-history)
9. [Tagging](#tagging)
10. [Advanced Operations](#advanced-operations)

---

## Setup & Configuration

### Initial Setup
```bash
# Set your name
git config --global user.name "Your Name"

# Set your email
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "nano"         # Nano
git config --global core.editor "vim"          # Vim
```

### Viewing Configuration
```bash
# View all settings
git config --list

# View specific setting
git config user.name
git config user.email

# View settings with source files
git config --list --show-origin
```

### Configuration Levels
```bash
# System-wide (all users)
git config --system [key] [value]

# User-wide (current user)
git config --global [key] [value]

# Repository-specific
git config --local [key] [value]
```

---

## Creating Repositories

### Initialize New Repository
```bash
# Create new Git repository in current directory
git init

# Create repository in specific directory
git init /path/to/directory

# Create bare repository (for servers)
git init --bare
```

### Clone Existing Repository
```bash
# Clone repository
git clone https://github.com/user/repo.git

# Clone with different folder name
git clone https://github.com/user/repo.git my-folder

# Clone specific branch
git clone -b develop https://github.com/user/repo.git

# Clone with depth (shallow clone)
git clone --depth=1 https://github.com/user/repo.git
```

---

## Basic Workflow

### Checking Status
```bash
# Show working directory status
git status

# Short format
git status -s

# Show untracked files
git status -u
```

### Staging Files
```bash
# Stage specific file
git add filename.txt

# Stage multiple files
git add file1.txt file2.txt

# Stage all changes (new, modified, deleted)
git add .

# Stage all changes in current directory
git add -A

# Stage only modified and deleted (not new files)
git add -u

# Stage interactively
git add -i

# Stage parts of files
git add -p filename.txt
```

### Committing Changes
```bash
# Commit staged changes
git commit -m "Commit message"

# Commit with detailed message (opens editor)
git commit

# Commit all tracked files (skip staging)
git commit -a -m "Commit message"

# Amend last commit (change message or add files)
git commit --amend -m "New message"

# Amend without changing message
git commit --amend --no-edit
```

### Viewing Changes
```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --staged

# Show changes in specific file
git diff filename.txt

# Show word-level changes
git diff --word-diff

# Show changes between commits
git diff commit1 commit2

# Show changes between branches
git diff branch1 branch2
```

---

## Branching & Merging

### Creating & Switching Branches
```bash
# List all local branches
git branch

# List all branches (local and remote)
git branch -a

# List remote branches only
git branch -r

# Create new branch
git branch feature-name

# Switch to branch
git checkout feature-name

# Create and switch to new branch
git checkout -b feature-name

# Create branch from specific commit
git checkout -b feature-name commit-hash

# Switch to previous branch
git checkout -
```

### Deleting Branches
```bash
# Delete merged branch
git branch -d feature-name

# Force delete unmerged branch
git branch -D feature-name

# Delete remote branch
git push origin --delete feature-name

# Prune deleted remote branches
git fetch --prune
```

### Merging Branches
```bash
# Merge branch into current branch
git merge feature-name

# Merge without fast-forward (create merge commit)
git merge --no-ff feature-name

# Merge and squash commits
git merge --squash feature-name

# Abort merge in progress
git merge --abort
```

### Rebasing
```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase (last 3 commits)
git rebase -i HEAD~3

# Continue rebase after resolving conflicts
git rebase --continue

# Skip current commit during rebase
git rebase --skip

# Abort rebase
git rebase --abort
```

---

## Remote Operations

### Managing Remotes
```bash
# List remotes
git remote

# List remotes with URLs
git remote -v

# Add remote
git remote add origin https://github.com/user/repo.git

# Add upstream remote (for forks)
git remote add upstream https://github.com/original/repo.git

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin upstream

# Change remote URL
git remote set-url origin https://github.com/user/new-repo.git

# Show remote details
git remote show origin
```

### Fetching Changes
```bash
# Fetch from origin
git fetch origin

# Fetch specific branch
git fetch origin main

# Fetch all remotes
git fetch --all

# Fetch and prune deleted branches
git fetch --prune
```

### Pulling Changes
```bash
# Pull from current branch's upstream
git pull

# Pull from specific remote and branch
git pull origin main

# Pull with rebase instead of merge
git pull --rebase

# Pull with fast-forward only
git pull --ff-only
```

### Pushing Changes
```bash
# Push to origin (current branch)
git push

# Push and set upstream
git push -u origin feature-name

# Push specific branch
git push origin feature-name

# Push all branches
git push --all

# Push tags
git push --tags

# Force push (dangerous!)
git push --force

# Safer force push
git push --force-with-lease

# Delete remote branch
git push origin --delete branch-name
```

---

## Undoing Changes

### Unstaging Files
```bash
# Unstage file (keep changes)
git restore --staged filename.txt

# Unstage all files
git restore --staged .

# Alternative (older method)
git reset HEAD filename.txt
```

### Discarding Changes
```bash
# Discard changes in specific file
git restore filename.txt

# Discard all changes in working directory
git restore .

# Alternative (older method)
git checkout -- filename.txt
```

### Resetting Commits
```bash
# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (unstage changes)
git reset HEAD~1
# or
git reset --mixed HEAD~1

# Undo last commit (delete changes) ⚠️ DANGER
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard commit-hash

# Reset to match remote
git reset --hard origin/main
```

### Reverting Commits
```bash
# Create new commit that undoes last commit
git revert HEAD

# Revert specific commit
git revert commit-hash

# Revert merge commit
git revert -m 1 merge-commit-hash

# Revert without committing
git revert --no-commit HEAD
```

### Recovering Lost Commits
```bash
# Show reference log (all actions)
git reflog

# Recover lost commit
git checkout commit-hash

# Create branch from lost commit
git checkout -b recovered-branch commit-hash

# Reset to specific reflog entry
git reset --hard HEAD@{2}
```

---

## Stashing

### Basic Stashing
```bash
# Stash current changes
git stash

# Stash with message
git stash save "Work in progress on feature X"

# Stash including untracked files
git stash -u

# Stash including ignored files
git stash -a
```

### Applying Stashes
```bash
# List all stashes
git stash list

# Apply most recent stash
git stash apply

# Apply specific stash
git stash apply stash@{2}

# Apply and remove stash
git stash pop

# Apply specific stash and remove
git stash pop stash@{0}
```

### Managing Stashes
```bash
# Show stash contents
git stash show

# Show stash contents with diff
git stash show -p

# Show specific stash
git stash show stash@{1}

# Delete specific stash
git stash drop stash@{0}

# Delete all stashes
git stash clear

# Create branch from stash
git stash branch new-branch-name
```

---

## Viewing History

### Basic Log
```bash
# View commit history
git log

# Compact one-line format
git log --oneline

# Show last N commits
git log -5

# Show commits with diffs
git log -p

# Show commit statistics
git log --stat

# Show commits as graph
git log --graph --oneline --all
```

### Filtering Log
```bash
# Commits by author
git log --author="John Doe"

# Commits since date
git log --since="2024-01-01"
git log --since="2 weeks ago"

# Commits until date
git log --until="2024-12-31"

# Commits with message containing text
git log --grep="fix bug"

# Commits affecting specific file
git log -- filename.txt

# Commits between two dates
git log --after="2024-01-01" --before="2024-12-31"
```

### Custom Log Format
```bash
# Custom format
git log --pretty=format:"%h - %an, %ar : %s"

# Placeholders:
# %H  - Full commit hash
# %h  - Abbreviated hash
# %an - Author name
# %ae - Author email
# %ad - Author date
# %ar - Author date (relative)
# %s  - Subject (commit message)
# %b  - Body

# Example: Detailed format
git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short
```

### Viewing Specific Commits
```bash
# Show commit details
git show commit-hash

# Show specific file from commit
git show commit-hash:path/to/file

# Show changes in commit
git show --stat commit-hash
```

---

## Tagging

### Creating Tags
```bash
# Create lightweight tag
git tag v1.0.0

# Create annotated tag (recommended)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag -a v1.0.0 commit-hash -m "Release 1.0.0"
```

### Viewing Tags
```bash
# List all tags
git tag

# List tags matching pattern
git tag -l "v1.*"

# Show tag details
git show v1.0.0
```

### Pushing Tags
```bash
# Push specific tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Push annotated tags only
git push origin --follow-tags
```

### Deleting Tags
```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Delete remote tag (alternative)
git push origin :refs/tags/v1.0.0
```

---

## Advanced Operations

### Cherry-Picking
```bash
# Apply specific commit to current branch
git cherry-pick commit-hash

# Cherry-pick without committing
git cherry-pick --no-commit commit-hash

# Cherry-pick multiple commits
git cherry-pick commit1 commit2 commit3

# Cherry-pick commit range
git cherry-pick commit1..commit5
```

### Cleaning Working Directory
```bash
# Show what would be deleted
git clean -n

# Delete untracked files
git clean -f

# Delete untracked files and directories
git clean -fd

# Delete ignored files too
git clean -fdx

# Interactive clean
git clean -i
```

### Searching
```bash
# Search for text in files
git grep "search term"

# Search with line numbers
git grep -n "search term"

# Search in specific commit
git grep "search term" commit-hash

# Search and show filename only
git grep -l "search term"
```

### Bisect (Binary Search for Bugs)
```bash
# Start bisect
git bisect start

# Mark current commit as bad
git bisect bad

# Mark known good commit
git bisect good commit-hash

# Mark current commit as good (Git will checkout next)
git bisect good

# Skip current commit
git bisect skip

# End bisect session
git bisect reset
```

### Submodules
```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# Initialize submodules
git submodule init

# Update submodules
git submodule update

# Clone with submodules
git clone --recursive https://github.com/user/repo.git

# Update all submodules to latest
git submodule update --remote
```

### Worktrees
```bash
# List worktrees
git worktree list

# Create new worktree
git worktree add ../project-feature feature-branch

# Create worktree with new branch
git worktree add -b new-branch ../project-new main

# Remove worktree
git worktree remove ../project-feature

# Prune deleted worktrees
git worktree prune
```

---

## 🚨 Emergency Commands

### When Things Go Wrong

```bash
# Lost commits? Check reflog
git reflog

# Recover deleted branch
git checkout -b recovered-branch commit-hash

# Undo last reset
git reset 'HEAD@{1}'

# Find orphaned commits
git fsck --lost-found

# Remove last commit but keep changes
git reset --soft HEAD~1

# Discard all local changes (⚠️ DANGER)
git reset --hard HEAD
git clean -fd

# Reset to match remote completely (⚠️ DANGER)
git fetch origin
git reset --hard origin/main
```

---

## 💡 Useful Aliases

Add these to `~/.gitconfig`:

```ini
[alias]
    # Short status
    st = status -s
    
    # Short log
    lg = log --oneline --graph --all --decorate
    
    # Detailed log
    lgg = log --graph --pretty=format:'%C(yellow)%h%C(reset) - %C(cyan)%an%C(reset) %C(green)(%ar)%C(reset)%n%C(white)%s%C(reset)%n' --abbrev-commit --all
    
    # Last commit
    last = log -1 HEAD --stat
    
    # Uncommit (undo last commit, keep changes)
    uncommit = reset --soft HEAD~1
    
    # Amend without editing message
    amend = commit --amend --no-edit
    
    # List aliases
    aliases = config --get-regexp alias
    
    # Undo last commit and changes (dangerous!)
    nuke = reset --hard HEAD~1
```

---

## 📊 Common Workflows

### Daily Development Workflow
```bash
# 1. Start day - get latest
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/new-feature

# 3. Work and commit
git add .
git commit -m "Add feature implementation"

# 4. Push feature branch
git push -u origin feature/new-feature

# 5. After PR approval, merge and clean up
git checkout main
git pull origin main
git branch -d feature/new-feature
```

### Hotfix Workflow
```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# 2. Fix and commit
git add .
git commit -m "Fix critical security issue"

# 3. Merge to main
git checkout main
git merge hotfix/critical-bug
git push origin main

# 4. Tag release
git tag -a v1.0.1 -m "Hotfix release"
git push origin v1.0.1

# 5. Clean up
git branch -d hotfix/critical-bug
```

### Contributing to Open Source
```bash
# 1. Fork on GitHub, then clone your fork
git clone https://github.com/YOUR-USERNAME/repo.git
cd repo

# 2. Add upstream remote
git remote add upstream https://github.com/ORIGINAL/repo.git

# 3. Create feature branch
git checkout -b fix/typo-in-docs

# 4. Make changes and commit
git add .
git commit -m "Fix typo in documentation"

# 5. Push to your fork
git push origin fix/typo-in-docs

# 6. Create Pull Request on GitHub

# 7. Keep your fork updated
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## ⚡ Quick Command Reference

| Category | Task | Command |
|----------|------|---------|
| **Status** | Check status | `git status` |
| **Stage** | Stage file | `git add <file>` |
| **Stage** | Stage all | `git add .` |
| **Commit** | Commit | `git commit -m "msg"` |
| **Branch** | List branches | `git branch` |
| **Branch** | Create branch | `git branch name` |
| **Branch** | Switch branch | `git checkout name` |
| **Branch** | Create & switch | `git checkout -b name` |
| **Merge** | Merge branch | `git merge branch` |
| **Remote** | Push | `git push origin main` |
| **Remote** | Pull | `git pull origin main` |
| **Remote** | Fetch | `git fetch origin` |
| **Undo** | Discard changes | `git restore file` |
| **Undo** | Unstage | `git restore --staged file` |
| **Undo** | Undo commit | `git reset HEAD~1` |
| **History** | View log | `git log --oneline` |
| **Stash** | Save work | `git stash` |
| **Stash** | Apply stash | `git stash pop` |

---

## 🎯 Remember

✅ **DO:**
- Commit often with clear messages
- Pull before you push
- Use branches for features
- Keep main branch stable
- Review changes before staging

❌ **DON'T:**
- Commit directly to main
- Force push to shared branches  
- Commit secrets or passwords
- Rebase public branches
- Use `git add .` blindly

---

**For more detailed explanations, see the full documentation series:**
1. [Foundation](01.foundation.md)
2. [Setting Up](02.setting_up.md)
3. [Basic Workflow](03.basic_work_flow.md)
4. [Branching & Merging](04.branching_and_merging.md)
5. [Collaboration](05.collaboration_with_github.md)
6. [Intermediate Techniques](06.intermediate_technique.md)
