#! /usr/bin/env bash
# Useful placeholders for git format:
# %cn - committer name, if you wanna call someone out
# %cd - commit date
# %cr - commit date, relative

declare gitFolder;

if test -n "$1"; then
    gitFolder=$1;
elif [ -d .git ] && echo .git || git rev-parse --git-dir > /dev/null 2>&1; then
    gitFolder=$(pwd);
else
    echo "Not in a git repository and no path specified. Exiting.";
    exit 1;
fi

echo $gitFolder

for branch in \
    `git -C $gitFolder branch -r --merged`; \
do \
    echo -e `git show --format="%cd %cr" $branch | head -n 1` \\t$branch; \
done | \
sort -r