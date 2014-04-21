Tool to setup a mysql replication slave by copying data and master status from a remote mysql master over ssh.

USAGE

    mysql_slaver help enslave

    mysql_slaver enslave --database=DATABASE --master-host=MASTER_HOST --replication-password=REPLICATION_PASSWORD --replication-user=REPLICATION_USER

BLOGPOST

  http://digitalronin.github.io/2014/04/16/mysql-slaver-gem-setup-mysql-replication/

ASSUMPTIONS/PRE-REQUISITES

* localhost is configured as a mysql replication slave
* the current localhost user can ssh to the db master
* any ssh config settings, other than a port number, required to access the master from localhost are set in a ~/.ssh/config file
* ssh is on the current user's path
* your mysql administrator user is called 'root', locally and on the db master
* mysql is on the local user's path
* mysql and mysqldump are on the remote ssh user's path
* replication permissions from the local host to the db master are already setup
* root user has the same password on this host and the master server
* mysql socket (if any) is the same on localhost and the db master
* db character set is UTF-8

CAVEATS

* destructively replaces the target database on localhost with no backup

TODO

* output better help (include optional params, format better (shorter lines))
* add a "no copying" mode that only updates master log file and position
* add a "dry-run" mode
* check ssh connection
* check replication permissions
* check slave is setup as a replication slave (i.e. it has a mysql server id)
* allow a mysql admin username other than 'root'
* allow different root user passwords on slave and master
