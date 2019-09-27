#!/bin/bash
cd "$(dirname "$0")"
MNE_VERSION=$(sed 's/^mne==\(.*\)$/\1/' ../versions.txt)
if [ -d "mne-tools.github.io" ]; then
  pushd mne-tools.github.io && git pull && popd
else
  git clone --depth 1 https://github.com/mne-tools/mne-tools.github.io
fi
cd mne-tools.github.io/
doc2dash -n MNE -d ../template/ -i ../template/icon@2x.png -j -u https://mne-tools.github.io/stable/ stable
cd ../template/
GZIP=-9 tar --exclude='.DS_Store' -cvzf MNE.tgz MNE.docset
rm -rf MNE.docset
cat docset.json
cat docset.json | sed "s/\(\"version\": \"\)\"/\1$MNE_VERSION\"/g" | tee docset.json
cat docset.json

cd ..
git config --global user.email "code@fehe.eu"
git config --global user.name "heilerich"

git clone https://github.com/Kapeli/Dash-User-Contributions.git

yes | cp -f template/* Dash-User-Contributions/docsets/MNE/
cd Dash-User-Contributions
git checkout -b pr-branch
git add *
git commit -m "Updating to MNE version $MNE_VERSION (Via Travis Build $TRAVIS_BUILD_ID)"

git remote add fork  https://heilerich:${GH_TOKEN}@github.com/heilerich/Dash-User-Contributions.git 
git push -u fork pr-branch 

