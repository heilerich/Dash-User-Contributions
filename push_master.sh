#!/bin/bash
setup_git() {
  git config --global user.email "code@fehe.eu"
  git config --global user.name "heilerich"
}

commit_files() {
  MNE_VERSION=$(cat docsets/MNE/docset.json | sed -n 's/.*version": "\(.*\)\".*/\1/p')
  git add docsets/*
  git commit -m "Updating to MNE version $MNE_VERSION (Via Travis Build $TRAVIS_BUILD_ID)"
}

upload_files() {
  git remote rm origin
  git remote add origin https://heilerich:${GH_TOKEN}@github.com/heilerich/Dash-User-Contributions.git 
  git push origin pr-branch 
}

pull_latest_master() {
  git remote rm origin
  git remote add origin https://github.com/Kapeli/Dash-User-Contributions.git
  git fetch
  git stash push docsets/*
  git checkout -f -b pr-branch origin/master
  git stash apply
}

setup_git

pull_latest_master

commit_files

upload_files
