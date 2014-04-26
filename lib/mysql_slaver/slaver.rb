# Setup the current server as a replication slave of a master mysql server,
# by dumping and loading a database, and issuing the appropriate change master
# command to mysql.
# This assumes that the current user can issue ssh commands to the master
# server (to get its master status, and to dump and load data over the ssh
# connection)
module MysqlSlaver
  class Slaver
    include Logger

    attr_reader :status_fetcher, :data_copier, :master_changer, :no_copy

    def initialize(params)
      mysql_root_password = params.fetch(:mysql_root_password, '')
      port                = params.fetch(:port, 3306)
      ssh_port            = params.fetch(:ssh_port, 22)
      socket_file         = params.fetch(:socket_file, nil)
      @no_copy            = params.fetch(:no_copy, false)

      @status_fetcher = params.fetch(:status_fetcher) {
        StatusFetcher.new(
          :master_host         => params.fetch(:master_host),
          :mysql_root_password => mysql_root_password,
          :socket_file         => socket_file,
          :ssh_port            => ssh_port
        )
      }

      @data_copier = params.fetch(:data_copier) {
        DbCopier.new(
          :master_host         => params.fetch(:master_host),
          :mysql_root_password => mysql_root_password,
          :database            => params.fetch(:database),
          :port                => port,
          :socket_file         => socket_file,
          :ssh_port            => ssh_port
        )
      }

      @master_changer = params.fetch(:master_changer) {
        MasterChanger.new(
          :master_host          => params.fetch(:master_host),
          :mysql_root_password  => mysql_root_password,
          :replication_user     => params.fetch(:replication_user),
          :replication_password => params.fetch(:replication_password),
          :port                 => port,
          :socket_file          => socket_file
        )
      }
    end

    def enslave!
      master_status = status_fetcher.status
      data_copier.copy! unless no_copy
      master_changer.change!(master_status)
    rescue Exception => e
      log e.message
    end
  end
end
