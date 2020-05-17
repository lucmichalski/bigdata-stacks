#!/bin/sh
# Gets version from the last changelog title

gitBranch=$(git branch | grep \* | cut -d ' ' -f2)
lastVersion=$(awk '$1 == "##"' CHANGELOG.md | awk 'NR==1')

if echo "$lastVersion" | grep -q -i 'unreleased'
then
    # If the last title is ## [Unreleased]
    # return dev- and the git branch name.
    echo "dev-$gitBranch"
    return 0
else
    echo "$lastVersion" | awk '{print $2}' | sed 's/^v//' | head -n1 | tr -d '[' | tr -d ']'
    return 0
fi