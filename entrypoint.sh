#!/bin/bash

cd ${GITHUB_WORKSPACE}

git diff --name-only origin/master | grep -P "(\.pl|\.pm|\.cgi)$" | scripts/bin/pt
