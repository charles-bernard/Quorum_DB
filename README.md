Quorum_DB  
==============================

Toolkit to initialize, fill, query and admin the Quorum_DB


# PREREQUISITES

##  0. Install postgresql to create, query and admin the database

Install postgresql

```bash
sudo apt-get install postgresql postgresql-contrib
```

## 1. Install the python library 'ete3' to retrieve easily taxonomic attributes of species

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

## 2. Install Entrez Programming Utilities to fetch fasta sequences from NCBI databases based on their ID.

[Download the package](http://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz)

Extract it and execute the setup.sh script

```bash
./edirect/setup.sh
````

You may need to place the edirect/ directory inside your $PATH

## 3. Install required packages for installing a local webserver

Update your machine

```bash
sudo apt update && sudo apt upgrade
```

Install apache2

```bash
sudo apt install apache2 apache2-utils
```

Install php

```bash
sudo apt install php php-pgsql libapache2-mod-php
```

# BACK END - The Postgresql Database

## 0. Grant yourself the CREATEDB, CREATE ROLE privileges

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

If you have created a role whose name matches your username, you should be able to open psql, simply as

```bash
psql
# But if you prefer to be more explicit you can also do:
psql -U <your_username>
```

Create the database quorum_db

```bash
CREATE DATABASE quorum_db;
```

If you type ```\l``` you will be proud to see that you are the owner of this database

Quit psql by typing ```\q```

## 3. Initialize the Quorum_DB (create the tables)

Change into the root of this repository

```bash
cd <path_to_Quorum_DB_repo>
```

And execute the ```create_tables.sql``` script as follow:

```bash
psql -U <your_username> -d quorum_db -f database/1_init_db/create_tables.sql
```

If you type ```\d``` inside psql, you will see all the tables that have been created

## 4. Populate the Quorum_DB

Change into the ```2_fill_db/``` directory

And open the ```ìnitial_table.template.csv``` file

This file is the primordial input from which Quorum_DB toolkit will populate all the different tables of the database and fetch all the sequences from the internet. If you want to enter your own entries, please respect meticulously the structure and the nomenclature of this template.

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
