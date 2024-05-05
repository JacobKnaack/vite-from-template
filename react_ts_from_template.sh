#!/usr/bin/env bash

# create a new vite project

eval "npm create vite@latest $1 -- --template react-ts"

# Create Variables for script and template directories

script_dir="$(dirname "$0")"
ab_path="$(pwd)"

# Install dependencies

dependencies=($(grep -o '"[^"]*"' $ab_path/$script_dir/configs/dependencies.json))
dependencyString=""
for dependency in "${dependencies[@]}"; do
  dependencyString="${dependencyString}${dependency} "
done
dependencyString="${dependencyString% }"
dependencyString=$(echo "$dependencyString" | tr -d "'\"")

eval "cd $1"
eval "npm install --save-dev $dependencyString"

# update vite config

eval "cp $ab_path/$script_dir/configs/vite/vite.config.ts ./vite.config.ts"

# create setup test files

eval "mkdir -p ./src/tests"
eval "cp $ab_path/$script_dir/configs/tests/setup.js ./src/tests/setup.ts"

# update package.json with test script

awk -v script_name=test -v script_command=vitest \
'/"scripts": {/{print; print "\t\t\"" script_name "\": \"" script_command "\","; next}1' package.json > temp.json

mv temp.json package.json
