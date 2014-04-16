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
* any ssh config settings for the host are set in a ~/.ssh/config file

CAVEATS

* destructively replaces the target database on localhost with no backup

TODO

* accept (and insist on) command-line parameters
* add a "no copying" mode that only updates master log file and position
* add a "dry-run" mode
* package as a gem
* check ssh connection and permissions
* check replication permissions
* allow overriding the mysql port
* allow ssh options
* make it work under ruby 2
