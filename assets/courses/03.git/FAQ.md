# Git Frequently Asked Questions (FAQ)

**Common questions and answers about Git and version control**

---

## Table of Contents

1. [General Questions](#general-questions)
2. [Getting Started](#getting-started)
3. [Basic Workflow Questions](#basic-workflow-questions)
4. [Branching Questions](#branching-questions)
5. [Collaboration Questions](#collaboration-questions)
6. [Troubleshooting Questions](#troubleshooting-questions)
7. [Best Practices](#best-practices)
8. [Advanced Topics](#advanced-topics)

---

## General Questions

### Q: What's the difference between Git and GitHub?

**A:** Git and GitHub are related but different:

- **Git**: Version control software that runs on your computer
  - Tracks changes in your code
  - Works completely offline
  - Free and open source
  - Created by Linus Torvalds

- **GitHub**: Web-based hosting service for Git repositories
  - Stores your repositories online
  - Provides collaboration tools (Pull Requests, Issues)
  - Offers web interface for Git
  - Owned by Microsoft

**Analogy:** Git is like Microsoft Word, GitHub is like Google Docs.

---

### Q: Do I need internet to use Git?

**A:** NO! Git works completely offline. You only need internet for:
- `git clone` - Getting a repository
- `git push` - Uploading changes
- `git pull` - Downloading changes  
- `git fetch` - Checking for remote changes

All other Git operations (commit, branch, merge, etc.) work offline.

---

### Q: Is Git difficult to learn?

**A:** Git has a learning curve, but it's manageable:

- **Easy**: Basic workflow (add, commit, push, pull)
- **Medium**: Branching, merging, conflict resolution
- **Advanced**: Rebasing, cherry-picking, bisecting

Most developers use the basic commands 90% of the time.

**Tip:** Learn the fundamentals first, then add advanced techniques gradually.

---

### Q: What are some alternatives to Git?

**A:** Other version control systems:

| System | Type | Best For |
|--------|------|----------|
| **Git** | Distributed | Most projects (most popular) |
| **Mercurial** | Distributed | Similar to Git, simpler |
| **SVN (Subversion)** | Centralized | Legacy projects |
| **Perforce** | Centralized | Large binary files, game dev |
| **CVS** | Centralized | Very old projects (deprecated) |

**Recommendation:** Use Git unless you have a specific reason not to.

---

## Getting Started

### Q: How do I install Git?

**A:** Installation varies by operating system:

**Windows:**
- Download from [git-scm.com](https://git-scm.com)
- Or use: `winget install Git.Git`

**macOS:**
- `brew install git` (if you have Homebrew)
- Or: `xcode-select --install`

**Linux:**
- Ubuntu/Debian: `sudo apt install git`
- Fedora: `sudo dnf install git`
- Arch: `sudo pacman -S git`

**Verify installation:** `git --version`

---

### Q: What should I set up after installing Git?

**A:** Configure your identity:

```bash
# Required: Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Optional but recommended:
git config --global init.defaultBranch main
git config --global core.editor "code --wait"  # Your preferred editor
git config --global pull.rebase false  # Merge behavior
```

**Important:** Use the same email as your GitHub account!

---

### Q: Should I use HTTPS or SSH for GitHub?

**A:** Both work, but have different pros/cons:

**HTTPS (Recommended for beginners):**
- ✅ Easier to set up
- ✅ Works through firewalls
- ✅ Uses Personal Access Tokens
- ❌ Need to enter credentials (can be cached)

**SSH (Recommended for advanced users):**
- ✅ More secure
- ✅ No password prompts after setup
- ✅ Can use with multiple accounts
- ❌ More complex initial setup

**Recommendation:** Start with HTTPS, switch to SSH when comfortable.

---

## Basic Workflow Questions

### Q: What's the difference between `git add` and `git commit`?

**A:** They serve different purposes in the workflow:

**`git add`:**
- Stages changes for commit
- Moves files to staging area
- You can selectively choose what to include
- Can be run multiple times

**`git commit`:**
- Saves staged changes permanently
- Creates a snapshot of your project
- Requires a message describing changes
- Can only commit what's staged

**Workflow:**
```
Modified Files → git add → Staged Files → git commit → Committed
```

---

### Q: Can I undo a `git add`?

**A:** YES! Unstage files with:

```bash
# Modern way (Git 2.23+)
git restore --staged filename.txt

# Unstage all files
git restore --staged .

# Older way (still works)
git reset HEAD filename.txt
```

---

### Q: What makes a good commit message?

**A:** Good commit messages are:

**Good Examples:**
```bash
git commit -m "Add user authentication feature"
git commit -m "Fix login bug on mobile devices"
git commit -m "Update dependencies to latest versions"
git commit -m "Refactor database connection handling"
```

**Bad Examples:**
```bash
git commit -m "stuff"
git commit -m "fix"
git commit -m "update"
git commit -m "changes"
```

**Best Practice Format:**
```bash
<type>(<scope>): <description>

# Types: feat, fix, docs, style, refactor, test, chore
# Examples:
git commit -m "feat(auth): add password reset functionality"
git commit -m "fix(ui): resolve button alignment on mobile"
git commit -m "docs(readme): update installation instructions"
```

---

### Q: How often should I commit?

**A:** Commit whenever you complete a logical unit of work:

**Too Frequent:** Every line of code
**Too Rare:** Once a week

**Just Right:**
- Added a function? Commit.
- Fixed a bug? Commit.
- Completed a feature? Commit.
- Updated documentation? Commit.

**Rule of Thumb:** 3-10 commits per day of active work.

---

### Q: What's the difference between `git pull` and `git fetch`?

**A:** They download changes differently:

**`git fetch`:**
- Downloads changes from remote
- Does NOT modify your files
- Safe - you can review before merging
- Updates remote-tracking branches

**`git pull`:**
- Downloads changes (fetch)
- Automatically merges into current branch (merge)
- Modifies your working directory
- Equivalent to: `git fetch` + `git merge`

**Recommendation:** Use `fetch` to preview, `pull` when you're ready to merge.

```bash
# Safe: Review first
git fetch origin
git log HEAD..origin/main  # See what's new
git pull origin main       # Then merge

# Quick: Fetch and merge in one step
git pull origin main
```

---

## Branching Questions

### Q: When should I create a new branch?

**A:** Create a branch for:

- ✅ Every new feature
- ✅ Every bug fix
- ✅ Any experimental work
- ✅ Before making significant changes
- ✅ When working on multiple things simultaneously

**Don't work directly on `main`!**

```bash
# Good practice
git checkout -b feature/user-profile
# ... work on feature ...
git checkout main
git merge feature/user-profile

# Bad practice
git checkout main
# ... work directly on main ... ❌
```

---

### Q: What's the difference between `git merge` and `git rebase`?

**A:** They integrate changes differently:

**Merge:**
- Combines branches with a merge commit
- Preserves complete history
- Shows when branches merged
- Safe for shared branches

**Rebase:**
- Re-applies commits on top of another branch
- Creates linear history
- Rewrites commit history
- ⚠️ **NEVER use on public/shared branches**

**When to use:**
- **Merge**: Always safe, especially for `main`
- **Rebase**: Only for local feature branches

```bash
# Merge (safe everywhere)
git checkout main
git merge feature-branch

# Rebase (only for local feature branches)
git checkout feature-branch
git rebase main  # Only if feature-branch not pushed!
```

---

### Q: Can I delete a branch I'm currently on?

**A:** NO! You must switch branches first:

```bash
# This won't work
git checkout feature-branch
git branch -d feature-branch  # ❌ Error!

# Do this instead
git checkout main
git branch -d feature-branch  # ✅ Works
```

---

### Q: How do I rename a branch?

**A:** Rename with `-m` flag:

```bash
# Rename current branch
git branch -m new-name

# Rename another branch
git branch -m old-name new-name

# If already pushed, update remote
git push origin -u new-name
git push origin --delete old-name
```

---

## Collaboration Questions

### Q: What is a Pull Request?

**A:** A Pull Request (PR) is:

- A request to merge your changes into another branch
- A GitHub/GitLab feature (not part of Git itself)
- A way to review code before merging
- A collaboration and discussion tool

**Workflow:**
1. Create feature branch
2. Make changes and commit
3. Push to GitHub
4. Create Pull Request on GitHub
5. Team reviews your code
6. Address feedback
7. PR gets merged

**Benefits:**
- Code review before merging
- Discussion of changes
- Automated testing (CI/CD)
- Documentation of decisions

---

### Q: What's the difference between cloning and forking?

**A:** Different ways to get a repository:

**Cloning:**
- Creates local copy on your computer
- Uses `git clone`
- Can push if you have permissions
- Used for your own repos or team repos

**Forking:**
- Creates your own copy on GitHub
- Done through GitHub web interface
- You always have push access (to your fork)
- Used for contributing to others' projects

**Example Workflow:**
```bash
# Working on your own project
git clone https://github.com/yourname/yourproject.git

# Contributing to someone else's project
# 1. Fork on GitHub (click Fork button)
# 2. Clone your fork
git clone https://github.com/yourname/theirproject.git
# 3. Add upstream
git remote add upstream https://github.com/theirname/theirproject.git
```

---

### Q: How do I keep my fork up to date?

**A:** Sync with the upstream repository:

```bash
# One-time setup: Add upstream remote
git remote add upstream https://github.com/original/repo.git

# Regular updates:
# 1. Fetch upstream changes
git fetch upstream

# 2. Merge into your main
git checkout main
git merge upstream/main

# 3. Push to your fork
git push origin main
```

---

## Troubleshooting Questions

### Q: Why does Git say "fatal: not a git repository"?

**A:** You're not in a Git repository:

**Fix:**
```bash
# Check current directory
pwd

# Look for .git folder
ls -la

# Either:
# 1. Initialize new repository
git init

# 2. Or navigate to existing repository
cd /path/to/your/repository
```

---

### Q: How do I undo the last commit?

**A:** Depends on whether you've pushed:

**If NOT pushed yet:**
```bash
# Undo commit, keep changes staged
git reset --soft HEAD~1

# Undo commit, unstage changes
git reset HEAD~1

# Undo commit, delete changes (⚠️ DANGER!)
git reset --hard HEAD~1
```

**If ALREADY pushed:**
```bash
# Create new commit that undoes previous one
git revert HEAD
git push origin main
```

---

### Q: I committed to the wrong branch! How do I fix it?

**A:** Move the commit to the correct branch:

```bash
# 1. Create new branch from current position (keeps commit)
git branch correct-branch

# 2. Go back to previous branch
git checkout previous-branch

# 3. Remove commit from wrong branch
git reset --hard HEAD~1

# 4. Switch to correct branch (has the commit now)
git checkout correct-branch

# All fixed!
```

---

### Q: How do I resolve merge conflicts?

**A:** Step by step resolution:

```bash
# 1. Attempt merge (causes conflict)
git merge feature-branch
# CONFLICT (content): Merge conflict in file.txt

# 2. Check which files have conflicts
git status

# 3. Open conflicted files, look for markers:
# <<<<<<< HEAD
# your changes
# =======
# their changes
# >>>>>>> branch-name

# 4. Edit file:
# - Remove conflict markers (<<<, ===, >>>)
# - Keep desired code (yours, theirs, or combination)
# - Save file

# 5. Stage resolved files
git add file.txt

# 6. Complete merge
git commit -m "Resolve merge conflict in file.txt"
```

**Tools to help:**
```bash
# Use visual merge tool
git mergetool

# Abort merge if needed
git merge --abort
```

---

### Q: My .gitignore isn't working. Why?

**A:** Git doesn't ignore files that are already tracked:

**Fix:**
```bash
# 1. Make sure .gitignore is correct
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore

# 2. Remove files from tracking (keeps local copy)
git rm --cached .env
git rm --cached -r node_modules/

# 3. Commit the removal
git commit -m "Stop tracking ignored files"

# 4. Now .gitignore will work for these files
```

---

### Q: I accidentally deleted a branch with important commits. Can I recover it?

**A:** YES! Use reflog to find and recover:

```bash
# 1. Find lost commits
git reflog

# Example output:
# abc1234 HEAD@{0}: checkout: moving from feature to main
# def5678 HEAD@{1}: commit: Important changes  ← This one!

# 2. Create new branch from lost commit
git checkout -b recovered-branch def5678

# Or cherry-pick specific commits
git cherry-pick def5678
```

---

### Q: Can I undo a `git reset --hard`?

**A:** Sometimes! If the commit existed:

```bash
# 1. Check reflog
git reflog

# 2. Find commit before reset
# Example: abc1234 HEAD@{1}: commit: My work

# 3. Reset to that commit
git reset --hard abc1234

# Note: This only works if changes were committed
# Uncommitted changes are lost forever!
```

---

## Best Practices

### Q: Should I commit sensitive information like passwords?

**A:** **ABSOLUTELY NOT!**

**Never commit:**
- ❌ Passwords
- ❌ API keys
- ❌ Private keys / certificates
- ❌ Database credentials
- ❌ Environment variables with secrets

**Instead:**
```bash
# 1. Use environment variables
# Create .env file (local only)
DATABASE_PASSWORD=secret123

# 2. Add to .gitignore
echo ".env" >> .gitignore

# 3. Create .env.example (safe to commit)
DATABASE_PASSWORD=your_password_here

# 4. Commit .env.example, never .env
git add .env.example
git commit -m "Add environment configuration template"
```

**If you accidentally committed secrets:**
```bash
# 1. Remove from tracking
git rm --cached .env

# 2. Commit removal
git commit -m "Remove sensitive file"

# 3. IMPORTANT: The secret is still in history!
# You must:
# - Rotate/change the secret immediately
# - Consider using git-filter-branch or BFG Repo-Cleaner
```

---

### Q: How do I write better commit messages?

**A:** Follow these guidelines:

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code restructure
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```bash
# Good
git commit -m "feat(auth): add JWT token authentication"
git commit -m "fix(ui): resolve mobile layout overflow issue"
git commit -m "docs(readme): update installation instructions for Windows"

# Better (with body)
git commit -m "feat(auth): add JWT token authentication

- Implement token generation and validation
- Add middleware for protected routes
- Update user model with token fields
- Add tests for authentication flow

Closes #123"
```

**Tips:**
- Use imperative mood ("Add feature" not "Added feature")
- First line ≤ 50 characters
- Body ≤ 72 characters per line
- Explain WHAT and WHY, not HOW

---

### Q: Should I use `git commit -a`?

**A:** Use with caution:

**What it does:**
```bash
# Stages AND commits all tracked files
git commit -a -m "Update everything"

# Equivalent to:
git add -u  # Stage modified and deleted files
git commit -m "Update everything"
```

**Pros:**
- ✅ Faster for quick updates
- ✅ Good for simple changes

**Cons:**
- ❌ Doesn't stage new files
- ❌ No chance to review changes
- ❌ Might commit unwanted changes

**Recommendation:**
```bash
# Better: Review first
git status
git diff
git add <specific-files>
git commit -m "Descriptive message"
```

---

## Advanced Topics

### Q: What is rebasing and when should I use it?

**A:** Rebasing re-applies your commits on top of another branch:

**Use rebase when:**
- ✅ Cleaning up local feature branch before merging
- ✅ Keeping linear history
- ✅ Squashing commits together
- ✅ **ONLY on local, un-pushed branches**

**Never rebase:**
- ❌ Public/shared branches
- ❌ Main/master branch
- ❌ Commits others have based work on

**Example:**
```bash
# Safe rebase (local feature branch)
git checkout feature-branch
git rebase main  # Only if feature-branch not pushed!

# Interactive rebase to clean up
git rebase -i HEAD~5  # Edit last 5 commits
```

**Golden Rule:** Never rebase commits that exist outside your repository!

---

### Q: What are Git hooks?

**A:** Scripts that run automatically on Git events:

**Common hooks:**
- `pre-commit`: Runs before commit (lint, test)
- `commit-msg`: Validates commit messages
- `pre-push`: Runs before push (tests)
- `post-receive`: Runs after push (deployment)

**Example pre-commit hook:**
```bash
# .git/hooks/pre-commit
#!/bin/sh

# Run tests
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed! Commit aborted."
    exit 1
fi

# Check for console.log
if grep -r "console.log" src/; then
    echo "Remove console.log statements!"
    exit 1
fi
```

**Tools:**
- Husky (Node.js)
- pre-commit (Python)
- git-hooks (Shell)

---

### Q: What's the difference between `git pull --rebase` and `git pull`?

**A:** They integrate remote changes differently:

**`git pull` (merge):**
```bash
# Fetches and merges
# Creates merge commit
git pull origin main

# Result:
#      A---B---C (your commits)
#     /         \
# ---D---E-------M (merge commit)
```

**`git pull --rebase`:**
```bash
# Fetches and rebases
# Linear history
git pull --rebase origin main

# Result:
# ---D---E---A'---B'---C' (rebased commits)
```

**Use rebase for:**
- Cleaner, linear history
- No merge commits
- When working alone

**Use merge for:**
- Preserving history
- Team collaboration
- Safer option

---

### Q: How do I squash commits?

**A:** Use interactive rebase:

```bash
# Squash last 4 commits
git rebase -i HEAD~4

# Editor opens with:
pick abc1234 Add feature part 1
pick def5678 Add feature part 2
pick ghi9012 Fix typo
pick jkl3456 Update tests

# Change to:
pick abc1234 Add feature part 1
squash def5678 Add feature part 2
squash ghi9012 Fix typo
squash jkl3456 Update tests

# Save and close
# Editor opens for commit message
# Edit and save
# Result: 4 commits → 1 commit
```

**⚠️ Only squash local commits!**

---

## Need More Help?

### Resources
- [Official Git Documentation](https://git-scm.com/doc)
- [Pro Git Book](https://git-scm.com/book) (Free)
- [GitHub Docs](https://docs.github.com/)
- [Git Cheat Sheet](git-cheat-sheet.md)

### Interactive Learning
- [Learn Git Branching](https://learngitbranching.js.org/)
- [GitHub Skills](https://skills.github.com/)

### Community
- [Stack Overflow - Git Tag](https://stackoverflow.com/questions/tagged/git)
- [Git Mailing List](https://git.wiki.kernel.org/index.php/GitCommunity)

---

**Don't see your question?** Check the [Git documentation series](README.md) or search [Stack Overflow](https://stackoverflow.com/questions/tagged/git).
