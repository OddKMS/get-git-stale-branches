#! /usr/bin/env bash
# Useful placeholders for git format:
# %cn - committer name, if you wanna call someone out
# %cd - commit date
# %cr - commit date, relative

declare gitFolder;
branchesToInclude=("origin/bugfix/*" "origin/feature/*" "origin/hotfix/*");

if test -n "$1"; then
    gitFolder=$1;
elif [ -d .git ] > /dev/null || git rev-parse --git-dir > /dev/null 2>&1; then
    gitFolder=$(pwd);
else
    echo "Not in a git repository and no path specified. Exiting.";
    exit 1;
fi

staleBranches=$( \
    for branch in \
        `git -C $gitFolder branch --list "${branchesToInclude[@]}" -r --merged`; \
    do \
        echo -e `git show --format="%cd %cr" --date="short" $branch | head -n 1` \\t${branch/'origin\/'/''}; \
    done | \
    sort -r \
)

if [ -z $staleBranches ]; then 
    exit 0;
else 
    echo "$staleBranches" > stale-branches.txt;
fi