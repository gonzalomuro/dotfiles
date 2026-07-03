#!/bin/bash

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

# Shorten path like fish's prompt_pwd:
# replace $HOME with ~, shorten each intermediate component to its first character
short=$(python3 -c "
import os, sys
path = sys.argv[1]
home = os.path.expanduser('~')
if path.startswith(home):
    path = '~' + path[len(home):]
parts = path.split('/')
result = []
for i, p in enumerate(parts):
    if i < len(parts) - 1 and p and p != '~':
        result.append(p[0])
    else:
        result.append(p)
print('/'.join(result))
" "$cwd" 2>/dev/null || echo "$cwd")

# Git branch (skip optional locks to avoid blocking)
git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Model name and context usage
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Directory in blue (mirrors fish prompt's colored cwd)
printf '\033[34m%s\033[0m' "$short"

# Git branch in cyan
if [ -n "$git_branch" ]; then
    printf ' \033[36m(%s)\033[0m' "$git_branch"
fi

# Model name in yellow
if [ -n "$model" ]; then
    printf ' \033[33m%s\033[0m' "$model"
fi

# Context usage in dim gray
if [ -n "$used" ]; then
    printf ' \033[90mctx:%.0f%%\033[0m' "$used"
fi

printf '\n'
