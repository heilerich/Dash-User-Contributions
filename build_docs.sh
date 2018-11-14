#!/bin/bash
MNE_VERSION=$(sed 's/^mne==\(.*\)$/\1/' mne_version.txt)
python3 download_mne.py
cd mne_source/mne*
conda env create -n mnedoc -f environment.yml -q
source activate mnedoc
pip install doc2dash
pip install .
cd doc
make html-noplot
doc2dash -n MNE -d ../../../mne_docset/ -i ../../../mne_docset/icon@2x.png -j -u https://mne-tools.github.io/stable/ _build/html_stable
cd ../../../mne_docset/
tar --exclude='.DS_Store' -cvzf MNE.tgz MNE.docset
rm -rf MNE.docset
cat docset.json | sed "s/\(\"version\": \"\)\"/\1$MNE_VERSION\"/g" | tee docset.json
cd ..
rm -rf mne_source
mv mne_docset docsets/MNE
rm download_mne.py
rm build_docs.sh
rm mne_version.txt
