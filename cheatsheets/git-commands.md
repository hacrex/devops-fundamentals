# 🌿 Git Commands Cheatsheet

## Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global core.editor vim
git config --list                        # View all config
```

## Init & Clone
```bash
git init                                 # New local repo
git clone url                            # Clone remote repo
git clone url --depth=1                  # Shallow clone
```

## Basic Workflow
```bash
git status                               # Check changes
git add file                             # Stage file
git add .                                # Stage all
git commit -m "message"                  # Commit
git commit --amend                       # Edit last commit
git push origin main                     # Push to remote
git pull origin main                     # Pull from remote
git fetch origin                         # Fetch without merge
```

## Branching
```bash
git branch                               # List branches
git branch feature-x                     # Create branch
git checkout feature-x                   # Switch branch
git checkout -b feature-x                # Create & switch
git merge feature-x                      # Merge branch
git branch -d feature-x                  # Delete branch
git push origin --delete feature-x       # Delete remote branch
```

## Stash
```bash
git stash                                # Save changes temporarily
git stash list                           # List stashes
git stash pop                            # Apply & remove stash
git stash apply stash@{0}               # Apply specific stash
git stash drop                           # Remove stash
```

## Log & Diff
```bash
git log                                  # Commit history
git log --oneline --graph                # Visual branch log
git log -p file                          # Changes per file
git diff                                 # Unstaged changes
git diff --staged                        # Staged changes
git diff branch1..branch2               # Branch diff
git blame file                           # Who changed what
```

## Undo & Reset
```bash
git restore file                         # Discard changes
git restore --staged file               # Unstage file
git revert commit_hash                   # Undo commit safely
git reset --soft HEAD~1                  # Undo commit, keep changes staged
git reset --mixed HEAD~1                 # Undo commit, keep changes unstaged
git reset --hard HEAD~1                  # Undo commit, discard changes ⚠️
```

## Remote
```bash
git remote -v                            # List remotes
git remote add origin url               # Add remote
git remote set-url origin url           # Change remote URL
git push -u origin main                 # Set upstream & push
git push --force-with-lease             # Safe force push
```

## Tags
```bash
git tag                                  # List tags
git tag v1.0.0                           # Create tag
git tag -a v1.0.0 -m "Release"          # Annotated tag
git push origin v1.0.0                  # Push tag
git push origin --tags                  # Push all tags
```

## Rebase
```bash
git rebase main                          # Rebase onto main
git rebase -i HEAD~3                     # Interactive rebase (last 3)
git rebase --abort                       # Cancel rebase
git rebase --continue                    # Continue after conflict
```

## Useful Tricks
```bash
git shortlog -sn                         # Commits per author
git cherry-pick commit_hash             # Apply specific commit
git bisect start                         # Binary search bug
git clean -fd                            # Remove untracked files
git reflog                               # History of HEAD moves
```
