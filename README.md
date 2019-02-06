Quorum_DB  
==============================

Toolkit to initialize, fill, query and admin the Quorum_DB

# BACK END - The Postgresql Database





## Wiki of the repository

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
* open python and tell ete3 to fetch NCBI taxonomy database

```python
from ete3 import NCBITaxa
ncbi = NCBITaxa()
ncbi.update_taxonomy_database()
```

## Nota Bene

Any .sql script present in this repository can be either executed via the shell:

```bash
psql -U <username> -d <dbname> -f <path_to_sql_script>
```

or within a psql session:

```SQL
\i <path_to_sql_script>
```
