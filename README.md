Tool to setup a mysql replication slave by copying data and master status from a remote mysql master over ssh.

ASSUMPTIONS/PRE-REQUISITES

* localhost is configured as a mysql replication slave
* the current localhost user can ssh to the db master
* your mysql administrator user is called 'root', locally and on the db master
* mysql is on the local user''s path
* mysql and mysqldump are on the remote ssh user''s path
* replication permissions from the local host to the db master are already setup
* mysql is running on the default port (3306)
* ssh is on the current user''s path
* db character set is UTF-8

CAVEATS

* !!!!!!! REPLICATION USER AND PASSWORD ARE HARD-CODED !!!!!!
* destructively replaces the target database on localhost with no backup

TODO

* write some tests
* tidy up the code with some DI
* require replication user and password as parameters
* accept (and insist on) command-line parameters
* a config file to be used, instead of command-line parameters
* package as a gem
* check ssh connection and permissions
* check replication permissions
* allow overriding the mysql port
* add a 'dry-run' option
* make it work under ruby 2
* suppress the "ERROR 1198 (HY000) at line 22: This operation cannot be performed with a running slave; run STOP SLAVE first
mysqldump: Got errno 32 on write" (I think this comes from the load step, which does a change master. Running 'stop slave' before doing the dump/load step should fix it)
