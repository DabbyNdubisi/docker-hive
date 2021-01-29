use mysql;
CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword';
GRANT ALL ON * . * TO 'hiveuser'@'%'; 
FLUSH PRIVILEGES;
create database metastore;
alter database metastore character set latin1;
