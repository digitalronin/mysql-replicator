Tool to setup a mysql replication slave by copying data and master status from a remote mysql master over ssh.

ASSUMPTIONS

* the current localhost user can ssh to the db master
* your mysql administrator user is called 'root', locally and on the db master
* mysql is on the local user''s path
* mysql and mysqldump are on the remote ssh user''s path
* replication permissions from the local host to the db master are already setup
* mysql is running on the default port (3306)

CAVEATS

* !!!!!!! REPLICATION USER AND PASSWORD ARE HARD-CODED !!!!!!
* destructively replaces the target database on localhost with no backup

TODO

* require replication user and password as parameters
* accept (and insist on) command-line parameters
* a config file to be used, instead of command-line parameters
* write some tests
* package as a gem
* check ssh connection and permissions
* check replication permissions
* allow overriding the mysql port
* add a 'dry-run' option
