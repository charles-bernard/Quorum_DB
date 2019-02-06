Quorum_DB  
==============================

Toolkit to initialize, fill, query and admin the Quorum_DB

# BACK END - The Postgresql Database

## 0. Prerequisites

Install postgresql

```bash
sudo apt-get install postgresql postgresql-contrib
```

install ete3 python library
```bash
pip install --upgrade ete3
```
then open a python terminal, import ete3 and fetch the NCBI taxonomy database

```python
from ete3 import NCBITaxa
ncbi = NCBITaxa()
ncbi.update_taxonomy_database()
```

## 1. Grant to yourself the CREATEDB, CREATE ROLE privileges

Open psql as postgresql superuser

```bash
sudo -i -u postgres
psql
```

Then create the role corresponding to your username

```bash
CREATE ROLE <your_username> WITH CREATEDB, CREATEROLE;
CREATE DATABASE <your_username>;
```

Type ```\du``` to visualize the privileges of all registered roles

Finally, quit psql by typing ```\q``` and deconnect as superuser by typing ```Ctrl+D```

## 2. Create the Quorum_DB database

Change into the root of this repository

```bash
cd <path_to_Quorum_DB_repo>
```

If you have created a role whose name matches your username, you should be able to open psql, simply as

```bash
psql
# But if you prefer to be more explicit you can also do:
psql -U <your_username>
```

Create the database quorum_db

```bash
CREATE DATABASE quorum_db
```

If you type ```\l``` you will be proud to see that you are the owner of this database

Quit psql by typing ```\q```

```psql```
## Nota Bene

Any .sql script present in this repository can be either executed via the shell:

```bash
psql -U <username> -d <dbname> -f <path_to_sql_script>
```

or within a psql session:

```SQL
\i <path_to_sql_script>
```


## Wiki of the repository

* [wiki](https://github.com/charles-bernard/Quorum_DB/wiki)
