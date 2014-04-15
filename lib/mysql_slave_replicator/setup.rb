# Setup the current server as a replication slave of a master mysql server,
# by dumping and loading a database, and issuing the appropriate change master
# command to mysql.
# This assumes that the current user can issue ssh commands to the master
# server (to get its master status, and to dump and load data over the ssh
# connection)
module MysqlSlaveReplicator
  class Setup
    attr_reader :status_fetcher, :data_copier, :master_changer

    def initialize(params)
      mysql_root_password  = params.fetch(:mysql_root_password, '')

      @status_fetcher = params.fetch(:status_fetcher) {
        MasterStatus.new(
          :master_host         => params.fetch(:master_host),
          :mysql_root_password => mysql_root_password
        )
      }

      @data_copier = params.fetch(:data_copier) {
        DbCopier.new(
          :master_host         => params.fetch(:master_host),
          :mysql_root_password => mysql_root_password,
          :database            => params.fetch(:database)
        )
      }

      @master_changer = params.fetch(:master_changer) {
        MasterChanger.new(
          :master_host          => params.fetch(:master_host),
          :mysql_root_password  => mysql_root_password,
          :file                 => status[:file],
          :position             => status[:position],
          :replication_user     => params.fetch(:replication_user),
          :replication_password => params.fetch(:replication_password)
        )
      }
    end

    def setup!
      master_status = status_fetcher.status
      data_copier.run
      master_changer.change!(master_status)
    end
  end
end
