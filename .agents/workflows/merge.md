---
description: Commit current code, merge current feature branch to main, and switch to main branch.
---

## Step 1 – Analyze and Commit Changes
1. Run `git status` to identify modified, deleted, and untracked files.
2. Run `git diff` or evaluate the content changes to understand the scope of the updates.
3. Group related files into logical chunks.
4. For each chunk, explicitly stage the files using `git add` and commit them with a concise, descriptive commit message explaining the change (`git commit -m "..."`).
   - If there are multiple unrelated changes, create multiple separate commits for clarity.

## Step 2 – Switch to main
1. First, identify and store the name of the current feature branch you are on.
2. Checkout the `main` branch using `git checkout main`.
3. (Optional but recommended) Run `git pull origin main` to ensure your local main branch is up-to-date with the remote repository.

## Step 3 – Merge feature branch
1. Merge the previously saved feature branch into main using `git merge <feature-branch-name>`.
2. Address any merge conflicts if they arise.
3. Once the merge is successful, optionally ask the user if they'd like to push to the remote repository.
