from urllib.request import urlretrieve, urlopen 
import zipfile
import os
import json

url = "https://api.github.com/repos/mne-tools/mne-python/tags"
res = urlopen(url)
res_body = res.read()
data = json.loads(res_body.decode("utf-8"))

with open("mne_version.txt") as f:
    version = f.read().split("==")[1].replace("\n", "")
    version = "v{}".format(version)

link = next((v for v in data if v['name'] == version), None)
urlretrieve(link['zipball_url'], "mne.zip")

zip_ref = zipfile.ZipFile("mne.zip", "r")
zip_ref.extractall("mne_source")
zip_ref.close()

os.remove("mne.zip")
