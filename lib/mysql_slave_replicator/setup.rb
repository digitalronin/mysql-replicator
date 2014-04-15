# Setup the current server as a replication slave of a master mysql server,
# by dumping and loading a database, and issuing the appropriate change master
# command to mysql.
# This assumes that the current user can issue ssh commands to the master
# server (to get its master status, and to dump and load data over the ssh
# connection)
module MysqlSlaveReplicator
  class Setup
    attr_accessor :master_host, :mysql_root_password, :database, :replication_user, :replication_password

    def initialize(params)
      @master_host          = params.fetch(:master_host)
      @database             = params.fetch(:database)
      @mysql_root_password  = params.fetch(:mysql_root_password, '')
      @replication_user     = params.fetch(:replication_user)
      @replication_password = params.fetch(:replication_password)
    end

    def setup!
      master_status = MasterStatus.new(
        :master_host         => master_host,
        :mysql_root_password => mysql_root_password
      ).status
      copy_data
      change_master(master_status)
    end

    private

    def copy_data
      DbCopier.new(
        :master_host         => master_host,
        :mysql_root_password => mysql_root_password,
        :database            => database
      ).run
    end
  end
end
