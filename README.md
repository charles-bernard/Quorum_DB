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

## 2. Install Entrez Programming Utilities to fetch publication informations based on Pubmed ID.

[Download the package](http://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz)

Extract it and execute the setup.sh script

You may need to place the edirect/ directory inside your $PATH


```bash
./edirect/setup.sh
```

## 3. Install openbabel to produce vectorial images of chemical structure from SMILES strings

```bash
sudo apt-get install openbabel
```

## 4. Install required packages for installing a local webserver

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
CREATE ROLE <your_username> WITH LOGIN CREATEDB CREATEROLE;
CREATE DATABASE <your_username>;
```

Type ```\du``` to visualize the privileges of all registered roles

Finally, quit psql by typing ```\q``` and disconnect as superuser by typing ```Ctrl+D```

## 2. Create the Quorum_DB database

If you have created a role whose name matches your username, you should be able to open psql, simply as

```bash
psql
```

If this does not work out, try:

```
psql -U <your_username>
```

Create the database quorum_db

```psql
CREATE DATABASE quorum_db;
```

If you type ```\l``` you will be proud to see that you are the owner of this database

Quit psql by typing ```\q```

## 3. Initialize the Quorum_DB (create the tables)

Change into the root of this repository

```bash
cd <path_to_Quorum_DB_repo>
```

And execute the ```create_tables.sql``` script as follows:

```bash
psql -U <your_username> -d quorum_db -f database/1_init_db/create_tables.sql
```

If you type ```\d``` inside psql, you will see all the tables that have been created

## 4. Populate the Quorum_DB

Change into the ```2_fill_db/``` directory

And open the ```ìnitial_table.template.csv``` file

This file is the primordial input from which Quorum_DB toolkit will populate all the different tables of the database and fetch all the sequences from the internet. If you want to enter your own entries, please respect meticulously the structure and the nomenclature of this template.

Execute the ```fill_db.py``` as follows:

```bash
python fill_db.py -u <your_username> -d quorum_db -i initial_table.template.csv -o ../../website/data
```

The output ```data/``` directory will contain the csv files used to populate the db as well as the fetched fasta sequences corresponding to the gene or protein entries.

## 5. Create views

Views are tables that often result from the combination of several input relations. If not optimal from a relational point of view, they are very convenient for visualization purposes. The view qs_summary will be displayed in the home page of the front end web application.

```bash
cd ../
psql -U <your_username> -d quorum_db -f database/3_create_views/create_views.sql
```

## 6. Back up Quorum_DB

Become postgres superuser

```bash
sudo -i -u postgres
```

And back up the db

```bash
pg_dump quorum_db > quorum_db.bak
```

To restore the db, do it the other way around

```bash
psql quorum_db < quorum_db.bak
```

## 7. Kill Quorum_DB

Change into the path of this repository, then execute the following script:

```bash
psql -U <your_username> -d quorum_db -f database/5_admin_db/drop_tables.sql
```

Then connect to psql ```psql``` and type:

```psql
DROP DATABASE quorum_db;
```

# FRONT END - The web browser

## 0. Create role 'visitor' with read only privileges on the db

Become postgresql superuser

```bash
sudo -i -u postgres
```

Then create role visitor

```psql```

```psql
CREATE ROLE visitor WITH LOGIN PASSWORD 'toto';
CREATE DATABASE visitor;
GRANT CONNECT ON DATABASE quorum_db TO visitor;
```

Quit psql ```\q``` but keep superuser identity to connect to the quorum_db and grant read only privileges 

```bash
psql quorum_db
```

```psql
GRANT USAGE ON SCHEMA public TO visitor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO visitor;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO visitor;
```

## 1. Configure your virtual host

open the file ```Quorum_DB/website/setup/webserver_quorum_db.conf.template``` into an editor

Replace string REPO_PATH and YOUR_EMAIL_ADDRESS by corresponding values

Then move the conf file inside the apache directory of available websites:

```bash
mv Quorum_DB/website/setup/webserver_quorum_db.conf.template /etc/apache2/sites-available/webserver_quorum_db.conf
```

Enable the website and reload apache2

```bash
sudo a2ensite webserver_quorum_db
sudo service apache2 reload
```

Add server quorum_db inside your list of hosts by simply adding the line ```127.0.0.1    webserver.dev``` to ```etc/hosts``` file

```bash
sudo gedit /etc/hosts
```
## 2. Enjoy!

The front end web browser of the Quorum DB is now serving at http://quorum_db
