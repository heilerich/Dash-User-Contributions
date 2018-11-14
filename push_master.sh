#!/bin/bash
setup_git() {
  git config --global user.email "code@fehe.eu"
  git config --global user.name "heilerich"
}

commit_files() {
  MNE_VERSION=$(cat docsets/MNE/docset.json | sed -n 's/.*version": "\(.*\)\".*/\1/p')
  git add docsets/*
  git commit -m "Updating to MNE version $MNE_VERSION (Via Travis Build $TRAVIS_BUILD_NUMBER)"
}

upload_files() {
  git remote rm origin
  git remote add origin https://heilerich:${GH_TOKEN}@github.com/heilerich/Dash-User-Contributions.git > /dev/null 2>&1
  git push origin master --quiet
}

pull_latest_master() {
  git remote rm origin https://github.com/Kapeli/Dash-User-Contributions.git
  git checkout master
  git pull contrib master
}

setup_git

pull_latest_master

commit_files

# Attempt to commit to git only if "git commit" succeeded
if [ $? -eq 0 ]; then
  echo "A new commit with changed country JSON files exists. Uploading to GitHub"
  upload_files
else
  echo "No changes in country JSON files. Nothing to do"
fi