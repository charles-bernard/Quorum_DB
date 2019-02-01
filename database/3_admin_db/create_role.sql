\prompt	'Type in the name of the database \n-> ' DB_NAME
\prompt 'Type in the username for the role \n-> ' USER_NAME

CREATE ROLE :USER_NAME;
CREATE DATABASE :USER_NAME;
GRANT CONNECT ON :DB_NAME TO :USER_NAME;
