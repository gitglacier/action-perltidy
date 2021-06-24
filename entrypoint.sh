#!/bin/bash

cd ${GITHUB_WORKSPACE}

git diff --name-only origin/master | grep -P "(\.pl|\.pm|\.cgi)$" | xargs scripts/bin/pt
