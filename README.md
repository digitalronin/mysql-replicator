
Tool to setup a mysql replication slave by copying data and master status from a remote mysql master over ssh.

USAGE

    mysql_slaver help enslave

    mysql_slaver enslave --database=DATABASE --master-host=MASTER_HOST --replication-password=REPLICATION_PASSWORD --replication-user=REPLICATION_USER

HOMEPAGE

  http://digitalronin.github.io/2014/04/16/mysql-slaver-gem-setup-mysql-replication/

ASSUMPTIONS/PRE-REQUISITES

* localhost is configured as a mysql replication slave
* the current localhost user can ssh to the db master
* your mysql administrator user is called 'root', locally and on the db master
* root user has the same password on this host and the master server
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
* check slave is setup as a replication slave (i.e. it has a mysql server id)
* allow overriding the mysql port
* allow overriding the mysql root user
* allow different root user passwords on slave and master
* allow ssh options
