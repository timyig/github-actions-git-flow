#!/bin/bash

# Delete local branches
for branch in $(git branch | grep '^act-'); do
  git branch -D $branch
done

# Delete remote branches
for branch in $(git branch -r | grep '^ *origin/act-'); do
  git push origin --delete ${branch#origin/}
  git remote prune origin
done
