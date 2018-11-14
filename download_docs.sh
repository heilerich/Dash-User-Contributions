#!/bin/bash
MNE_VERSION=$(sed 's/^mne==\(.*\)$/\1/' mne_version.txt)
git clone https://github.com/mne-tools/mne-tools.github.io
cd mne-tools.github.io/
doc2dash -n MNE -d ../mne_docset/ -i ../mne_docset/icon@2x.png -j -u https://mne-tools.github.io/stable/ stable
cd ../mne_docset/
tar --exclude='.DS_Store' -cvzf MNE.tgz MNE.docset
rm -rf MNE.docset
cat docset.json | sed "s/\(\"version\": \"\)\"/\1$MNE_VERSION\"/g" | tee docset.json
cd ..
mv mne_docset docsets/MNE
rm download_docs.sh
rm mne_version.txt
