Quorum_DB  
==============================

Toolkit to initialize, fill, update and admin the Quorum_DB

## wiki of the repository

* [wiki](https://github.com/charles-bernard/Quorum_DB/wiki)

## Prerequisites

* install postgres

```bash
sudo apt-get install postgresql postgresql-contrib
```

* install ete3 python library

```bash
pip install --upgrade ete3
```
* tell ete3 to fetch NCBI taxonomy database

```python
from ete3 import NCBITaxa
ncbi = NCBITaxa()
ncbi.update_taxonomy_database()
```
